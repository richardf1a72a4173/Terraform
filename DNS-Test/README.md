<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.7.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.29.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.29.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_peer_DNS"></a> [peer\_DNS](#module\_peer\_DNS) | ../Modules/Peering | n/a |
| <a name="module_peer_bastion"></a> [peer\_bastion](#module\_peer\_bastion) | ../Modules/Peering | n/a |
| <a name="module_vnet"></a> [vnet](#module\_vnet) | ../Modules/VNET | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_linux_virtual_machine.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_network_interface.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_security_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->