<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | ~>2.11 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>5.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~>3.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azapi"></a> [azapi](#provider\_azapi) | ~>2.11 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~>5.0 |
| <a name="provider_null"></a> [null](#provider\_null) | ~>3.2 |

## Resources

| Name | Type |
|------|------|
| [azapi_resource.apic_apim_environment](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) | resource |
| [azapi_resource.apic_apim_source](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) | resource |
| [azapi_resource.apic_git_environment](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) | resource |
| [azapi_resource.apic_git_source](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) | resource |
| [null_resource.apic_data_api_settings](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apic_id"></a> [apic\_id](#input\_apic\_id) | The resource ID of the API Center service to configure (output of the apicenter module). | `string` | n/a | yes |
| <a name="input_apic_principal_id"></a> [apic\_principal\_id](#input\_apic\_principal\_id) | The principal ID of the API Center service's system-assigned managed identity (output of the apicenter module). | `string` | n/a | yes |
| <a name="input_name_suffix"></a> [name\_suffix](#input\_name\_suffix) | A short suffix string (e.g. the first 3 characters of the root module's resource\_token) to centrally mitigate resource name collisions. | `string` | n/a | yes |
| <a name="input_apim_resource_ids"></a> [apim\_resource\_ids](#input\_apim\_resource\_ids) | Resource IDs of existing Azure API Management instances to synchronize APIs from. One apiSource is created per resource ID. Set to an empty list to skip API Management integration. The API Center service's managed identity must be granted the 'API Management Service Reader Role' on each instance (see the apicenter\_apim\_reader role assignment in the root module). | `list(string)` | `[]` | no |
| <a name="input_enable_marketplace_endpoint"></a> [enable\_marketplace\_endpoint](#input\_enable\_marketplace\_endpoint) | Enable the API Center plugin marketplace data-plane endpoint. | `bool` | `false` | no |
| <a name="input_enable_mcp_endpoint"></a> [enable\_mcp\_endpoint](#input\_enable\_mcp\_endpoint) | Enable the API Center data-plane MCP endpoint used to discover registered MCP servers. | `bool` | `false` | no |
| <a name="input_git_import_specification"></a> [git\_import\_specification](#input\_git\_import\_specification) | Whether to import the specification file along with metadata for assets synchronized from Git. One of: always, never, ondemand. | `string` | `"ondemand"` | no |
| <a name="input_git_pat_secret_uri"></a> [git\_pat\_secret\_uri](#input\_git\_pat\_secret\_uri) | Key Vault secret URI (e.g. https://<vault>.vault.azure.net/secrets/<name>) holding the Git personal access token used to authenticate to the repositories. Applied to every URL in git\_repository\_urls. Leave empty for public repositories. | `string` | `""` | no |
| <a name="input_git_repository_urls"></a> [git\_repository\_urls](#input\_git\_repository\_urls) | URLs of Git repositories to synchronize API Center assets from, each optionally including /tree/<branch>/<subfolder>. One apiSource is created per URL. Set to an empty list to skip Git repository integration. | `list(string)` | `[]` | no |
| <a name="input_visibility_asset_kinds"></a> [visibility\_asset\_kinds](#input\_visibility\_asset\_kinds) | Asset 'kind' values made visible through the API Center data-plane API (portal, consumption features). Set to an empty list to make every asset visible. | `list(string)` | <pre>[<br/>  "mcp",<br/>  "skill",<br/>  "plugin",<br/>  "agent"<br/>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_apim_environment_id"></a> [apim\_environment\_id](#output\_apim\_environment\_id) | The resource ID of the environment representing linked API Management instances |
| <a name="output_apim_source_ids"></a> [apim\_source\_ids](#output\_apim\_source\_ids) | Resource IDs of the API Management-backed API sources, one per entry in var.apim\_resource\_ids |
| <a name="output_git_environment_id"></a> [git\_environment\_id](#output\_git\_environment\_id) | The resource ID of the environment representing linked Git repositories |
| <a name="output_git_source_ids"></a> [git\_source\_ids](#output\_git\_source\_ids) | Resource IDs of the Git-backed API sources, one per entry in var.git\_repository\_urls |
<!-- END_TF_DOCS -->
