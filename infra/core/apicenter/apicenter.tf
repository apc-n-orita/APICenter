terraform {
  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = "~>2.11"
    }
  }
}

# ------------------------------------------------------------------------------------------------------
# DEPLOY AZURE API CENTER
# No azurerm_api_center resource exists in the azurerm provider (as of 5.0), so this service is
# managed through azapi. Only the service instance itself lives in this module; its internal
# configuration (Git integration, data-plane visibility, ...) lives in the apicenter-config module.
# ------------------------------------------------------------------------------------------------------
resource "azapi_resource" "apic" {
  type      = "Microsoft.ApiCenter/services@2024-06-01-preview"
  name      = var.name
  parent_id = var.rg_id
  location  = var.location
  tags      = var.tags

  # The published swagger for this preview API version omits `sku`, which the live service actually
  # accepts and returns. Verified against a live API Center instance via `az rest`.
  schema_validation_enabled = false

  identity {
    type = "SystemAssigned"
  }

  body = {
    sku = {
      name = var.sku_name
    }
  }

  response_export_values = [
    "properties.portalHostname",
  ]
}
