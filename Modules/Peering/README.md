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
| [azurerm_virtual_network_peering.from](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering) | resource |
| [azurerm_virtual_network_peering.to](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_from_remote_vnet_id"></a> [from\_remote\_vnet\_id](#input\_from\_remote\_vnet\_id) | Remote vNet ID | `string` | n/a | yes |
| <a name="input_from_vnet_name"></a> [from\_vnet\_name](#input\_from\_vnet\_name) | Local vNet Name | `string` | n/a | yes |
| <a name="input_from_vnet_peer_name"></a> [from\_vnet\_peer\_name](#input\_from\_vnet\_peer\_name) | Local vNet Peer Name | `string` | n/a | yes |
| <a name="input_remote_rg_name"></a> [remote\_rg\_name](#input\_remote\_rg\_name) | Remote Resource Group Name | `string` | n/a | yes |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | Local Resource Group Name | `string` | n/a | yes |
| <a name="input_to_remote_vnet_id"></a> [to\_remote\_vnet\_id](#input\_to\_remote\_vnet\_id) | Remote vNet ID | `string` | n/a | yes |
| <a name="input_to_vnet_name"></a> [to\_vnet\_name](#input\_to\_vnet\_name) | Remote vNet Name | `string` | n/a | yes |
| <a name="input_to_vnet_peer_name"></a> [to\_vnet\_peer\_name](#input\_to\_vnet\_peer\_name) | Remote vNet Peer Name | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->