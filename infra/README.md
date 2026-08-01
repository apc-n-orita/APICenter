<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.7, < 2.0.0 |
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | ~>2.11 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~>3.5.0 |
| <a name="requirement_azurecaf"></a> [azurecaf](#requirement\_azurecaf) | ~>1.2.24 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>5.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | ~>0.14 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 3.5.0 |
| <a name="provider_azurecaf"></a> [azurecaf](#provider\_azurecaf) | 1.2.34 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 5.0.1 |
| <a name="provider_time"></a> [time](#provider\_time) | 0.14.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_apicenter"></a> [apicenter](#module\_apicenter) | ./core/apicenter | n/a |
| <a name="module_apicenter_config"></a> [apicenter\_config](#module\_apicenter\_config) | ./core/apicenter-config | n/a |
| <a name="module_keyvault"></a> [keyvault](#module\_keyvault) | ./core/security/keyvault | n/a |

## Resources

| Name | Type |
|------|------|
| [azurecaf_name.kv_name](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurerm_role_assignment.apicenter_apim_reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.apicenter_kv_secrets_user](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [time_sleep.apicenter_rbac_propagation](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [azuread_client_config.current](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/client_config) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_log_analytics_workspace.law](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/log_analytics_workspace) | data source |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment_name"></a> [environment\_name](#input\_environment\_name) | The name of the azd environment to be deployed | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The supported Azure location where the resource deployed | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_name"></a> [log\_analytics\_workspace\_name](#input\_log\_analytics\_workspace\_name) | Name of the existing Log Analytics workspace, in resource\_group\_name, that Key Vault diagnostic logs (all categories) and metrics are sent to. Leave empty to skip diagnostic settings. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the existing resource group to deploy resources into. | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure subscription ID | `string` | n/a | yes |
| <a name="input_apicenter_apim_resource_ids"></a> [apicenter\_apim\_resource\_ids](#input\_apicenter\_apim\_resource\_ids) | Comma-separated list of resource IDs of existing Azure API Management instances for API Center to synchronize APIs from. Leave empty to skip API Management integration. | `string` | `""` | no |
| <a name="input_apicenter_git_repository_urls"></a> [apicenter\_git\_repository\_urls](#input\_apicenter\_git\_repository\_urls) | Comma-separated list of Git repository URLs (each optionally including /tree/<branch>/<subfolder>) that API Center synchronizes skill/mcp-server/agent assets from. Leave empty to skip Git repository integration. | `string` | `""` | no |
| <a name="input_github_pat"></a> [github\_pat](#input\_github\_pat) | GitHub personal access token used by API Center's Git repository integration to read the catalog repository. Stored in Key Vault as the 'github-apicenter-pat' secret. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_APICENTER_NAME"></a> [APICENTER\_NAME](#output\_APICENTER\_NAME) | n/a |
| <a name="output_APICENTER_PORTAL_HOSTNAME"></a> [APICENTER\_PORTAL\_HOSTNAME](#output\_APICENTER\_PORTAL\_HOSTNAME) | n/a |
| <a name="output_AZURE_KEY_VAULT_ENDPOINT"></a> [AZURE\_KEY\_VAULT\_ENDPOINT](#output\_AZURE\_KEY\_VAULT\_ENDPOINT) | n/a |
| <a name="output_AZURE_KEY_VAULT_NAME"></a> [AZURE\_KEY\_VAULT\_NAME](#output\_AZURE\_KEY\_VAULT\_NAME) | n/a |
| <a name="output_AZURE_LOCATION"></a> [AZURE\_LOCATION](#output\_AZURE\_LOCATION) | n/a |
| <a name="output_AZURE_TENANT_ID"></a> [AZURE\_TENANT\_ID](#output\_AZURE\_TENANT\_ID) | n/a |
<!-- END_TF_DOCS -->