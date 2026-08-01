terraform {
  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = "~>2.11"
    }
    azurerm = {
      version = "~>5.0"
      source  = "hashicorp/azurerm"
    }
    null = {
      source  = "hashicorp/null"
      version = "~>3.2"
    }
  }
}

data "azurerm_client_config" "current" {}

locals {
  apic_data_api_settings_body = jsonencode({
    properties = {
      enableMcp                 = var.enable_mcp_endpoint
      enableMarketplaceEndpoint = var.enable_marketplace_endpoint
      visibilityFilter = length(var.visibility_asset_kinds) == 0 ? {} : {
        apis = [
          {
            property = "kind"
            operator = "contains"
            value    = var.visibility_asset_kinds
          }
        ]
      }
    }
  })
}

# ------------------------------------------------------------------------------------------------------
# PORTAL SETTINGS > DATA API SETTINGS
# Controls which assets are exposed through the data-plane API (and therefore the API Center portal):
# API visibility filter, MCP endpoint, plugin marketplace endpoint.
#
# Azure auto-creates this "default" dataApiSettings child resource the moment the parent API Center
# service exists (verified against a live instance), and both azapi_resource (create semantics) and
# azapi_update_resource (silently no-ops on this endpoint) fail to actually apply changes to it here.
# `az rest` against the same endpoint was verified (manually, against a live instance) to work, so
# this shells out to it via local-exec instead, re-running whenever the desired body changes.
# ------------------------------------------------------------------------------------------------------
resource "null_resource" "apic_data_api_settings" {
  triggers = {
    body_hash = sha256(local.apic_data_api_settings_body)
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<-EOT
      az rest \
        --method PUT \
        --url "https://management.azure.com${var.apic_id}/dataApiSettings/default?api-version=2024-06-01-preview" \
        --body '${local.apic_data_api_settings_body}'
    EOT
  }
}

# ------------------------------------------------------------------------------------------------------
# GIT REPOSITORY INTEGRATION (Platforms > Integrations > "From Git repository")
# Creates the target environment and the Git-backed API source that regularly syncs assets
# (skills, MCP servers, agents) from the repository into the API Center inventory.
# The environment is always created; only the apiSource (the actual link) is toggled by
# var.git_repository_url.
# ------------------------------------------------------------------------------------------------------
resource "azapi_resource" "apic_git_environment" {
  type      = "Microsoft.ApiCenter/services/workspaces/environments@2024-06-01-preview"
  name      = "github"
  parent_id = "${var.apic_id}/workspaces/default"

  body = {
    properties = {
      title       = "GitHub"
      kind        = "production"
      description = "Represents the linked Git repository as a source of synchronized API Center assets."
    }
  }
}

resource "azapi_resource" "apic_git_source" {
  for_each = { for idx, url in var.git_repository_urls : tostring(idx) => url }

  type      = "Microsoft.ApiCenter/services/workspaces/apiSources@2024-06-01-preview"
  name      = "git-${var.name_suffix}-${each.key}"
  parent_id = "${var.apic_id}/workspaces/default"

  # azapi's embedded schema only documents the azureApiManagementSource variant of apiSources; the
  # Git-backed variant (apiSourceType/gitSource/sourceLifecycleStage) is undocumented but is what the
  # Azure portal actually writes when you use Platforms > Integrations > "From Git repository".
  schema_validation_enabled = false

  body = {
    properties = {
      apiSourceType        = "Git"
      importSpecification  = var.git_import_specification
      sourceLifecycleStage = "design"
      targetLifecycleStage = "design"
      targetEnvironmentId  = "/workspaces/default/environments/${azapi_resource.apic_git_environment.name}"
      gitSource = {
        gitProvider   = "github"
        repositoryUrl = each.value
        msiResourceId = "${data.azurerm_client_config.current.tenant_id}/${var.apic_principal_id}/systemAssigned"
        assetTypes = [
          { assetType = "skill", filesToInclude = "**/SKILL.md" },
          { assetType = "mcp-server", filesToInclude = "**/server.json" },
          { assetType = "agent", filesToInclude = "**/agent.md" },
        ]
        patKey = var.git_pat_secret_uri == "" ? null : var.git_pat_secret_uri
        repositoryAuth = var.git_pat_secret_uri == "" ? null : {
          authenticationType = "PersonalAccessToken"
          pat = {
            secretRef = var.git_pat_secret_uri
          }
        }
      }
    }
  }

  depends_on = [azapi_resource.apic_git_environment]

}

# ------------------------------------------------------------------------------------------------------
# API MANAGEMENT INTEGRATION (Platforms > Integrations > "From Azure API Management")
# Kept as its own environment/apiSource pair, independent from the Git repository integration above,
# so either can be enabled, changed, or removed without affecting the other. The environment is always
# created; only the apiSource (the actual link) is toggled by var.apim_resource_id.
# ------------------------------------------------------------------------------------------------------
resource "azapi_resource" "apic_apim_environment" {
  type      = "Microsoft.ApiCenter/services/workspaces/environments@2024-06-01-preview"
  name      = "apim"
  parent_id = "${var.apic_id}/workspaces/default"

  body = {
    properties = {
      title       = "Azure API Management"
      kind        = "production"
      description = "Represents the linked Azure API Management instance as a source of synchronized APIs."
      server = {
        # Matches the value the service itself returns/expects at runtime, which differs from the
        # 'Azure API Management' enum label shown in the published Bicep/ARM docs.
        type = "azure-api-management"
      }
    }
  }
}

resource "azapi_resource" "apic_apim_source" {
  for_each = { for idx, id in var.apim_resource_ids : tostring(idx) => id }

  type      = "Microsoft.ApiCenter/services/workspaces/apiSources@2024-06-01-preview"
  name      = "apim-${var.name_suffix}-${each.key}"
  parent_id = "${var.apic_id}/workspaces/default"

  # azapi's embedded schema only documents the bare azureApiManagementSource shape; apiSourceType and
  # sourceLifecycleStage are undocumented but match what the live control plane actually stores (see
  # the apiSourceType/apimSource/sourceLifecycleStage fields on a portal-created integration).
  schema_validation_enabled = false

  body = {
    properties = {
      apiSourceType        = "Apim"
      importSpecification  = var.apim_import_specification
      sourceLifecycleStage = "design"
      targetLifecycleStage = "production"
      targetEnvironmentId  = "/workspaces/default/environments/${azapi_resource.apic_apim_environment.name}"
      apimSource = {
        resourceId    = each.value
        msiResourceId = "${data.azurerm_client_config.current.tenant_id}/${var.apic_principal_id}/systemAssigned"
      }

      azureApiManagementSource = {
        resourceId    = each.value
        msiResourceId = "${data.azurerm_client_config.current.tenant_id}/${var.apic_principal_id}/systemAssigned"
      }
    }
  }

  depends_on = [azapi_resource.apic_apim_environment]

}
