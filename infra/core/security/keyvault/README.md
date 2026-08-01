<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~>5.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault.kv](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_key_vault_secret.secrets](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_monitor_diagnostic_setting.kv](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_role_assignment.secrets_officer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.secrets_user](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | The supported Azure location where the resource deployed | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the key vault (typically CAF-named by the caller, e.g. via azurecaf\_name). | `string` | n/a | yes |
| <a name="input_principal_id"></a> [principal\_id](#input\_principal\_id) | The Id of the principal to grant the 'Key Vault Secrets Officer' RBAC role (read/write secrets). | `string` | n/a | yes |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | The name of the resource group to deploy resources into | `string` | n/a | yes |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | A list of secrets to be added to the keyvault | <pre>list(object({<br/>    name  = string<br/>    value = string<br/>  }))</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A list of tags used for deployed services. | `map(string)` | n/a | yes |
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | Resource ID of the Log Analytics workspace to send Key Vault diagnostic logs (all log categories) and metrics to. Set to an empty string to skip diagnostic settings. | `string` | `""` | no |
| <a name="input_secrets_user_object_ids"></a> [secrets\_user\_object\_ids](#input\_secrets\_user\_object\_ids) | A list of object ids to grant the 'Key Vault Secrets User' RBAC role (read-only secrets access). | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_AZURE_KEY_VAULT_ENDPOINT"></a> [AZURE\_KEY\_VAULT\_ENDPOINT](#output\_AZURE\_KEY\_VAULT\_ENDPOINT) | n/a |
| <a name="output_id"></a> [id](#output\_id) | The resource ID of the key vault, used to scope role assignments |
| <a name="output_name"></a> [name](#output\_name) | The name of the key vault |
| <a name="output_vault_uri"></a> [vault\_uri](#output\_vault\_uri) | The URI of the key vault |
<!-- END_TF_DOCS -->