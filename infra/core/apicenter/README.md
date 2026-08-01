<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | ~>2.11 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azapi"></a> [azapi](#provider\_azapi) | ~>2.11 |

## Resources

| Name | Type |
|------|------|
| [azapi_resource.apic](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | The supported Azure location where the resource deployed | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the API Center service (typically CAF-named by the caller). | `string` | n/a | yes |
| <a name="input_rg_id"></a> [rg\_id](#input\_rg\_id) | The resource ID of the resource group to deploy resources into | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A list of tags used for deployed services. | `map(string)` | n/a | yes |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | The pricing tier of the API Center service. Possible values are Free and Standard. | `string` | `"Free"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The resource ID of the API Center service |
| <a name="output_name"></a> [name](#output\_name) | The name of the API Center service |
| <a name="output_portal_hostname"></a> [portal\_hostname](#output\_portal\_hostname) | The hostname of the API Center portal |
| <a name="output_principal_id"></a> [principal\_id](#output\_principal\_id) | The principal ID of the API Center service's system-assigned managed identity |
<!-- END_TF_DOCS -->
