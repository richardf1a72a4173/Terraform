<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.5 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 4.29.0 |
| <a name="requirement_http"></a> [http](#requirement\_http) | ~> 3.5.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | ~> 0.13.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.29.0 |
| <a name="provider_azurerm.platform"></a> [azurerm.platform](#provider\_azurerm.platform) | 4.29.0 |
| <a name="provider_time"></a> [time](#provider\_time) | ~> 0.13.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_container_group.container](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/container_group) | resource |
| [azurerm_management_lock.rg](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/management_lock) | resource |
| [azurerm_nat_gateway.nat](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/nat_gateway) | resource |
| [azurerm_nat_gateway_public_ip_association.nat](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/nat_gateway_public_ip_association) | resource |
| [azurerm_network_security_group.nsg](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.rules](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/network_security_rule) | resource |
| [azurerm_private_dns_zone_virtual_network_link.links](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_public_ip.nat](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/public_ip) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/resource_group) | resource |
| [azurerm_subnet.subnet](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/subnet) | resource |
| [azurerm_subnet_nat_gateway_association.nat](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/subnet_nat_gateway_association) | resource |
| [azurerm_subnet_network_security_group_association.subnet](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/virtual_network) | resource |
| [time_static.time](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/data-sources/client_config) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/data-sources/subscription) | data source |
| [azurerm_virtual_hub.us](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/data-sources/virtual_hub) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ad"></a> [ad](#input\_ad) | Active Directory | `string` | `"n/a"` | no |
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | Application Name | `string` | `"n/a"` | no |
| <a name="input_arm_client_secret"></a> [arm\_client\_secret](#input\_arm\_client\_secret) | ARM Client Secret | `string` | `""` | no |
| <a name="input_client_certificate_password"></a> [client\_certificate\_password](#input\_client\_certificate\_password) | SPN Client Certificate Password | `string` | `""` | no |
| <a name="input_client_certificate_path"></a> [client\_certificate\_path](#input\_client\_certificate\_path) | SPN Client Certificate Path | `string` | `""` | no |
| <a name="input_confidentiality"></a> [confidentiality](#input\_confidentiality) | Confidentiality | `string` | `"n/a"` | no |
| <a name="input_cost_centre"></a> [cost\_centre](#input\_cost\_centre) | Cost Centre | `string` | `"n/a"` | no |
| <a name="input_country_tag"></a> [country\_tag](#input\_country\_tag) | {us,eu} Country Tag for resource naming | `string` | `"us"` | no |
| <a name="input_dns_zones"></a> [dns\_zones](#input\_dns\_zones) | The Private DNS Zones to be linked | <pre>map(object({<br/>    short_name = string<br/>    name       = string<br/>  }))</pre> | <pre>{<br/>  "acr": {<br/>    "name": "privatelink.azurecr.io",<br/>    "short_name": "acr"<br/>  },<br/>  "azurewebsites": {<br/>    "name": "privatelink.azurewebsites.net",<br/>    "short_name": "azurewebsites"<br/>  },<br/>  "blob": {<br/>    "name": "privatelink.blob.core.windows.net",<br/>    "short_name": "blob"<br/>  },<br/>  "database": {<br/>    "name": "privatelink.database.windows.net",<br/>    "short_name": "database"<br/>  },<br/>  "file": {<br/>    "name": "privatelink.file.core.windows.net",<br/>    "short_name": "file"<br/>  },<br/>  "mysql": {<br/>    "name": "privatelink.mysql.database.azure.com",<br/>    "short_name": "mysql"<br/>  },<br/>  "redis": {<br/>    "name": "privatelink.redis.cache.windows.net",<br/>    "short_name": "redis"<br/>  },<br/>  "servicebus": {<br/>    "name": "privatelink.servicebus.windows.net",<br/>    "short_name": "servicebus"<br/>  },<br/>  "vaultcore": {<br/>    "name": "privatelink.vaultcore.azure.net",<br/>    "short_name": "vaultcore"<br/>  }<br/>}</pre> | no |
| <a name="input_docker_registry_password"></a> [docker\_registry\_password](#input\_docker\_registry\_password) | Docker Registry Password | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment Type | `map(string)` | <pre>{<br/>  "Dev": "d",<br/>  "Prod": "p",<br/>  "Test": "t"<br/>}</pre> | no |
| <a name="input_environment_tag"></a> [environment\_tag](#input\_environment\_tag) | {Dev,Test,Prod} Environement Tag | `string` | n/a | yes |
| <a name="input_git_repo_pass"></a> [git\_repo\_pass](#input\_git\_repo\_pass) | GIT Repo Password | `string` | `""` | no |
| <a name="input_nsg_map"></a> [nsg\_map](#input\_nsg\_map) | Map of NSG Rules | <pre>map(object({<br/>    name                    = string<br/>    priority                = string<br/>    direction               = string<br/>    access                  = string<br/>    protocol                = string<br/>    destination_port_range  = string<br/>    source_address_prefixes = list(string)<br/>  }))</pre> | <pre>{<br/>  "4000": {<br/>    "access": "Deny",<br/>    "destination_port_range": "*",<br/>    "direction": "Inbound",<br/>    "name": "DenyInbound",<br/>    "priority": "4000",<br/>    "protocol": "*",<br/>    "source_address_prefixes": [<br/>      "10.0.0.0/8",<br/>      "192.168.0.0/16",<br/>      "172.16.0.0/12"<br/>    ]<br/>  }<br/>}</pre> | no |
| <a name="input_ops_team"></a> [ops\_team](#input\_ops\_team) | Operations Team | `string` | `"Azure Engineering"` | no |
| <a name="input_project_code"></a> [project\_code](#input\_project\_code) | Project Code | `string` | `"n/a"` | no |
| <a name="input_project_tag"></a> [project\_tag](#input\_project\_tag) | Project Tag | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Azure Region | `string` | `"eastus2"` | no |
| <a name="input_service_hours"></a> [service\_hours](#input\_service\_hours) | Application Service Hours | `string` | `"n/a"` | no |
| <a name="input_service_level"></a> [service\_level](#input\_service\_level) | Application Service Level | `string` | `"n/a"` | no |
| <a name="input_snet_subnets"></a> [snet\_subnets](#input\_snet\_subnets) | SNET Subnet CIDRs | `list(string)` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure Subscription ID | `string` | n/a | yes |
| <a name="input_vnet_change"></a> [vnet\_change](#input\_vnet\_change) | Change Record to cover VNET Peering | `string` | `""` | no |
| <a name="input_vnet_subnet"></a> [vnet\_subnet](#input\_vnet\_subnet) | VNET Subnet CIDR | `list(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->