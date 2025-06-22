<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.5 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 4.29.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.29.0 |
| <a name="provider_azurerm.platform"></a> [azurerm.platform](#provider\_azurerm.platform) | 4.29.0 |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_network_security_group.eu-nsg](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/network_security_group) | resource |
| [azurerm_network_security_group.nsg-us-ie](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/network_security_group) | resource |
| [azurerm_network_security_group.nsg-us-oe](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.eu-rules-ie](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.eu-rules-oe](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/network_security_rule) | resource |
| [azurerm_private_dns_resolver.eu](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/private_dns_resolver) | resource |
| [azurerm_private_dns_resolver.us](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/private_dns_resolver) | resource |
| [azurerm_private_dns_resolver_dns_forwarding_ruleset.eu](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/private_dns_resolver_dns_forwarding_ruleset) | resource |
| [azurerm_private_dns_resolver_dns_forwarding_ruleset.us](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/private_dns_resolver_dns_forwarding_ruleset) | resource |
| [azurerm_private_dns_resolver_inbound_endpoint.eu-ie](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/private_dns_resolver_inbound_endpoint) | resource |
| [azurerm_private_dns_resolver_inbound_endpoint.us-ie](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/private_dns_resolver_inbound_endpoint) | resource |
| [azurerm_private_dns_resolver_outbound_endpoint.eu-oe](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/private_dns_resolver_outbound_endpoint) | resource |
| [azurerm_private_dns_resolver_outbound_endpoint.us-oe](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/private_dns_resolver_outbound_endpoint) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/resource_group) | resource |
| [azurerm_subnet.eu-subnet](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/subnet) | resource |
| [azurerm_subnet.us-ie](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/subnet) | resource |
| [azurerm_subnet.us-oe](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.eu-nsg](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_virtual_hub_connection.eu](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/virtual_hub_connection) | resource |
| [azurerm_virtual_network.eu](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/virtual_network) | resource |
| [azurerm_virtual_network.us](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/virtual_network) | resource |
| [time_static.time](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/data-sources/client_config) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/data-sources/subscription) | data source |
| [azurerm_virtual_hub.eu](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/data-sources/virtual_hub) | data source |
| [azurerm_virtual_hub.us](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/data-sources/virtual_hub) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ad"></a> [ad](#input\_ad) | Active Directory | `string` | `"n/a"` | no |
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | Application Name | `string` | `"n/a"` | no |
| <a name="input_confidentiality"></a> [confidentiality](#input\_confidentiality) | Confidentiality | `string` | `"n/a"` | no |
| <a name="input_cost_centre"></a> [cost\_centre](#input\_cost\_centre) | Cost Centre | `string` | `"n/a"` | no |
| <a name="input_country_tag"></a> [country\_tag](#input\_country\_tag) | {us,eu} Country Tag for resource naming | `string` | `"us"` | no |
| <a name="input_country_tag2"></a> [country\_tag2](#input\_country\_tag2) | {us,eu} Country Tag for resource naming | `string` | `"eu"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment Type | `map(string)` | <pre>{<br/>  "Dev": "d",<br/>  "Prod": "p",<br/>  "Test": "t"<br/>}</pre> | no |
| <a name="input_environment_tag"></a> [environment\_tag](#input\_environment\_tag) | {Dev,Test,Prod} Environement Tag | `any` | n/a | yes |
| <a name="input_nsg_map_eu_ie"></a> [nsg\_map\_eu\_ie](#input\_nsg\_map\_eu\_ie) | Map of NSG Rules | <pre>map(object({<br/>    name                    = string<br/>    priority                = string<br/>    direction               = string<br/>    access                  = string<br/>    protocol                = string<br/>    destination_port_range  = string<br/>    source_address_prefixes = list(string)<br/>  }))</pre> | <pre>{<br/>  "4000": {<br/>    "access": "Deny",<br/>    "destination_port_range": "*",<br/>    "direction": "Inbound",<br/>    "name": "DenyInbound",<br/>    "priority": "4000",<br/>    "protocol": "*",<br/>    "source_address_prefixes": [<br/>      "10.0.0.0/8",<br/>      "192.168.0.0/16",<br/>      "172.16.0.0/12"<br/>    ]<br/>  }<br/>}</pre> | no |
| <a name="input_nsg_map_eu_oe"></a> [nsg\_map\_eu\_oe](#input\_nsg\_map\_eu\_oe) | Map of NSG Rules | <pre>map(object({<br/>    name                    = string<br/>    priority                = string<br/>    direction               = string<br/>    access                  = string<br/>    protocol                = string<br/>    destination_port_range  = string<br/>    source_address_prefixes = list(string)<br/>  }))</pre> | <pre>{<br/>  "4000": {<br/>    "access": "Deny",<br/>    "destination_port_range": "*",<br/>    "direction": "Inbound",<br/>    "name": "DenyInbound",<br/>    "priority": "4000",<br/>    "protocol": "*",<br/>    "source_address_prefixes": [<br/>      "10.0.0.0/8",<br/>      "192.168.0.0/16",<br/>      "172.16.0.0/12"<br/>    ]<br/>  }<br/>}</pre> | no |
| <a name="input_ops_team"></a> [ops\_team](#input\_ops\_team) | Operations Team | `string` | `"Azure Engineering"` | no |
| <a name="input_project_code"></a> [project\_code](#input\_project\_code) | Project Code | `string` | `"n/a"` | no |
| <a name="input_project_tag"></a> [project\_tag](#input\_project\_tag) | Project Tag | `any` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Azure Region | `string` | `"eastus2"` | no |
| <a name="input_region2"></a> [region2](#input\_region2) | Azure Region | `string` | `"westeurope"` | no |
| <a name="input_region2-snets"></a> [region2-snets](#input\_region2-snets) | Second Region Subnets | `any` | n/a | yes |
| <a name="input_region2-vnet"></a> [region2-vnet](#input\_region2-vnet) | Second VNET Subnet | `any` | n/a | yes |
| <a name="input_service_hours"></a> [service\_hours](#input\_service\_hours) | Application Service Hours | `string` | `"n/a"` | no |
| <a name="input_service_level"></a> [service\_level](#input\_service\_level) | Application Service Level | `string` | `"n/a"` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure Subscription ID | `any` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->