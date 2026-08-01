# Declare output values for the main terraform module.
#
# This allows the main terraform module outputs to be referenced by other modules,
# or by the local machine as a way to reference created resources in Azure for local development.
# Secrets should not be added here.
#
# Outputs are automatically saved in the local azd environment .env file.
# To see these outputs, run `azd env get-values`. `azd env get-values --output json` for json output.

output "AZURE_LOCATION" {
  value = var.location
}

output "AZURE_TENANT_ID" {
  value = data.azurerm_client_config.current.tenant_id
}

output "AZURE_KEY_VAULT_NAME" {
  value = module.keyvault.name
}

output "AZURE_KEY_VAULT_ENDPOINT" {
  value     = module.keyvault.vault_uri
  sensitive = true
}

output "APICENTER_NAME" {
  value = module.apicenter.name
}

output "APICENTER_PORTAL_HOSTNAME" {
  value = module.apicenter.portal_hostname
}
