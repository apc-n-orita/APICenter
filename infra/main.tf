locals {
  tags           = { azd-env-name : var.environment_name }
  sha            = base64encode(sha256("${var.environment_name}${var.location}${data.azurerm_client_config.current.subscription_id}"))
  resource_token = substr(replace(lower(local.sha), "[^A-Za-z0-9_]", ""), 0, 13)

  apicenter_git_repository_urls = [for url in split(",", var.apicenter_git_repository_urls) : trimspace(url) if trimspace(url) != ""]
  apicenter_apim_resource_ids   = [for id in split(",", var.apicenter_apim_resource_ids) : trimspace(id) if trimspace(id) != ""]
}

# Deploy into an existing resource group rather than creating a new one.
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

# Add resources to be provisioned below.
# To learn more, https://developer.hashicorp.com/terraform/tutorials/azure-get-started/azure-change
# Note that a tag:
#   azd-service-name: "<service name in azure.yaml>"
# should be applied to targeted service host resources, such as:
#  azurerm_linux_web_app, azurerm_windows_web_app for appservice
#  azurerm_function_app for function

# Existing Log Analytics workspace (in the same resource group) that Key Vault diagnostic logs/metrics
# are sent to (optional).
data "azurerm_log_analytics_workspace" "law" {
  name                = var.log_analytics_workspace_name
  resource_group_name = var.resource_group_name
}

# ------------------------------------------------------------------------------------------------------
# KEY VAULT
# Azure RBAC authorization is enabled. It holds the GitHub PAT used by API Center's Git integration.
# ------------------------------------------------------------------------------------------------------
resource "azurecaf_name" "kv_name" {
  name          = var.environment_name
  resource_type = "azurerm_key_vault"
  random_length = 0
  clean_input   = true
}

module "keyvault" {
  source = "./core/security/keyvault"

  name                       = "${azurecaf_name.kv_name.result}-${substr(local.resource_token, 0, 3)}"
  location                   = data.azurerm_resource_group.rg.location
  rg_name                    = data.azurerm_resource_group.rg.name
  tags                       = local.tags
  principal_id               = data.azurerm_client_config.current.object_id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.law.id

  secrets = [
    {
      name  = "github-apicenter-pat"
      value = var.github_pat
    }
  ]
}

# ------------------------------------------------------------------------------------------------------
# API CENTER
# ------------------------------------------------------------------------------------------------------
module "apicenter" {
  source = "./core/apicenter"

  # No azurecaf resource_type exists for Microsoft.ApiCenter/services, so the name is built by hand,
  # following the same "<caf-or-manual-name>-<3-char-token>" convention as the other resources above.
  name     = "apic-${var.environment_name}-${substr(local.resource_token, 0, 3)}"
  location = var.location
  rg_id    = data.azurerm_resource_group.rg.id
  tags     = local.tags
  sku_name = "Free"
}

# Grant the API Center service's managed identity access to read the GitHub PAT secret used for
# its Git repository integration.
resource "azurerm_role_assignment" "apicenter_kv_secrets_user" {
  scope                = module.keyvault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.apicenter.principal_id
}

# Grant the API Center service's managed identity access to read APIs from each linked API Management
# instance. Required for the API Management integration, independent of the Git repository integration.
resource "azurerm_role_assignment" "apicenter_apim_reader" {
  for_each             = toset(local.apicenter_apim_resource_ids)
  scope                = each.value
  role_definition_name = "API Management Service Reader Role"
  principal_id         = module.apicenter.principal_id
}

# Azure AD role assignments take a little time to propagate; apicenter-config's Git/APIM apiSources
# fail with a permissions error if they're created immediately after the role assignments above.
resource "time_sleep" "apicenter_rbac_propagation" {
  create_duration = "30s"
  depends_on = [
    azurerm_role_assignment.apicenter_kv_secrets_user,
    azurerm_role_assignment.apicenter_apim_reader,
  ]
}

# API Center's internal configuration (Git integration, data-plane visibility, ...), split out from
# the service instance itself so the two can be reasoned about and changed independently.
module "apicenter_config" {
  source = "./core/apicenter-config"

  apic_id                     = module.apicenter.id
  apic_principal_id           = module.apicenter.principal_id
  name_suffix                 = substr(local.resource_token, 0, 3)
  enable_mcp_endpoint         = false
  enable_marketplace_endpoint = false
  visibility_asset_kinds      = []

  git_repository_urls      = local.apicenter_git_repository_urls
  git_import_specification = "always"
  git_pat_secret_uri       = "${module.keyvault.vault_uri}secrets/github-apicenter-pat"

  apim_resource_ids         = local.apicenter_apim_resource_ids
  apim_import_specification = "always"

  depends_on = [time_sleep.apicenter_rbac_propagation]
}
