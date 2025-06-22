<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_nat_gateway.nat](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nat_gateway) | resource |
| [azurerm_nat_gateway_public_ip_association.nat](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nat_gateway_public_ip_association) | resource |
| [azurerm_public_ip.nat](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_subnet.subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | Resource Location | `string` | n/a | yes |
| <a name="input_nat_gateway"></a> [nat\_gateway](#input\_nat\_gateway) | Provision a NAT gateway for outbound access | `bool` | `false` | no |
| <a name="input_resource_template"></a> [resource\_template](#input\_resource\_template) | Resource Name Template | `string` | `"-vnet-"` | no |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | Resource Group Name | `string` | n/a | yes |
| <a name="input_snet_address"></a> [snet\_address](#input\_snet\_address) | Subnet Address Space | `string` | n/a | yes |
| <a name="input_snet_name"></a> [snet\_name](#input\_snet\_name) | SNet Name | `string` | `"snet-vnet-001"` | no |
| <a name="input_vnet_address"></a> [vnet\_address](#input\_vnet\_address) | vNet Address Space | `string` | n/a | yes |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | Name of vNet | `string` | `"vnet-vnet-001"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_snet_id"></a> [snet\_id](#output\_snet\_id) | SNet ID |
| <a name="output_snet_name"></a> [snet\_name](#output\_snet\_name) | SNet Name |
| <a name="output_vnet_id"></a> [vnet\_id](#output\_vnet\_id) | vNet ID |
| <a name="output_vnet_name"></a> [vnet\_name](#output\_vnet\_name) | vNet Name |
<!-- END_TF_DOCS -->