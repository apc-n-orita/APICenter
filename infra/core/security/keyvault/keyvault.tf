terraform {
  required_providers {
    azurerm = {
      version = "~>5.0"
      source  = "hashicorp/azurerm"
    }
  }
}

data "azurerm_client_config" "current" {}
# ------------------------------------------------------------------------------------------------------
# DEPLOY AZURE KEYVAULT
# Authorization is exclusively via Azure RBAC; access policies are not used by this module.
# ------------------------------------------------------------------------------------------------------
resource "azurerm_key_vault" "kv" {
  name                       = var.name
  location                   = var.location
  resource_group_name        = var.rg_name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled   = false
  sku_name                   = "standard"
  rbac_authorization_enabled = true

  tags = var.tags
}

resource "azurerm_role_assignment" "secrets_officer" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = var.principal_id
}

resource "azurerm_role_assignment" "secrets_user" {
  for_each             = toset(var.secrets_user_object_ids)
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = each.value
}

resource "azurerm_key_vault_secret" "secrets" {
  # Secret names aren't sensitive, only their values are, but var.secrets is marked sensitive as a
  # whole, so for_each needs the names unwrapped from that marking (nonsensitive) to key off them.
  for_each     = nonsensitive({ for s in var.secrets : s.name => true })
  name         = each.key
  value        = { for s in var.secrets : s.name => s.value }[each.key]
  key_vault_id = azurerm_key_vault.kv.id
  depends_on = [
    azurerm_role_assignment.secrets_officer,
    azurerm_role_assignment.secrets_user,
  ]
}

# ------------------------------------------------------------------------------------------------------
# DIAGNOSTIC SETTINGS
# Ships all log categories and all metrics to the Log Analytics workspace supplied by the caller.
# ------------------------------------------------------------------------------------------------------
resource "azurerm_monitor_diagnostic_setting" "kv" {
  name                       = "send-to-law"
  target_resource_id         = azurerm_key_vault.kv.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category_group = "allLogs"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}
