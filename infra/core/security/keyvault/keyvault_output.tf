output "AZURE_KEY_VAULT_ENDPOINT" {
  value     = azurerm_key_vault.kv.vault_uri
  sensitive = true
}

output "id" {
  description = "The resource ID of the key vault, used to scope role assignments"
  value       = azurerm_key_vault.kv.id
}

output "vault_uri" {
  description = "The URI of the key vault"
  value       = azurerm_key_vault.kv.vault_uri
}

output "name" {
  description = "The name of the key vault"
  value       = azurerm_key_vault.kv.name
}