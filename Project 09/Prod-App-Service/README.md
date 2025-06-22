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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_dns-links"></a> [dns-links](#module\_dns-links) | ../../Modules/DNS-Zone-Links | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_application_gateway.ag](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/application_gateway) | resource |
| [azurerm_application_insights.app](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/application_insights) | resource |
| [azurerm_application_security_group.asg](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/application_security_group) | resource |
| [azurerm_key_vault.kv](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/key_vault) | resource |
| [azurerm_key_vault_access_policy.app](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_certificate.ssl](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/key_vault_certificate) | resource |
| [azurerm_key_vault_key.sql](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/key_vault_key) | resource |
| [azurerm_key_vault_secret.sql](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/key_vault_secret) | resource |
| [azurerm_linux_web_app.app](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/linux_web_app) | resource |
| [azurerm_linux_web_app_slot.prod](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/linux_web_app_slot) | resource |
| [azurerm_linux_web_app_slot.staging](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/linux_web_app_slot) | resource |
| [azurerm_mysql_flexible_database.database](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/mysql_flexible_database) | resource |
| [azurerm_mysql_flexible_server.mysql](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/mysql_flexible_server) | resource |
| [azurerm_network_security_group.nsg](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.app-gw-rules](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.app-service-rules](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.appgw-clients](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.appgw-gateway](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.appgw-loadbalancer](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.pe-rules](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.sql-rules](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/network_security_rule) | resource |
| [azurerm_public_ip.pip](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/public_ip) | resource |
| [azurerm_redis_cache.redis](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/redis_cache) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/resource_group) | resource |
| [azurerm_service_plan.plan](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/service_plan) | resource |
| [azurerm_storage_account.storage](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/storage_account) | resource |
| [azurerm_storage_share.share](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/storage_share) | resource |
| [azurerm_subnet.app](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/subnet) | resource |
| [azurerm_subnet.app-gw](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/subnet) | resource |
| [azurerm_subnet.pe](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/subnet) | resource |
| [azurerm_subnet.redis](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/subnet) | resource |
| [azurerm_subnet.sql](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.app](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_network_security_group_association.app-gw](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_network_security_group_association.pe](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_network_security_group_association.redis](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_subnet_network_security_group_association.sql](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_user_assigned_identity.ag](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/user_assigned_identity) | resource |
| [azurerm_user_assigned_identity.sql](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/user_assigned_identity) | resource |
| [azurerm_virtual_hub_connection.us](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/virtual_hub_connection) | resource |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/virtual_network) | resource |
| [azurerm_web_application_firewall_policy.waf](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/web_application_firewall_policy) | resource |
| [time_static.time](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/data-sources/client_config) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/data-sources/subscription) | data source |
| [azurerm_virtual_hub.us](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/data-sources/virtual_hub) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ad"></a> [ad](#input\_ad) | Active Directory | `string` | `"n/a"` | no |
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | Application Name | `string` | `"n/a"` | no |
| <a name="input_confidentiality"></a> [confidentiality](#input\_confidentiality) | Confidentiality | `string` | `"n/a"` | no |
| <a name="input_cost_centre"></a> [cost\_centre](#input\_cost\_centre) | Cost Centre | `string` | `"n/a"` | no |
| <a name="input_country_tag"></a> [country\_tag](#input\_country\_tag) | {us,eu} Country Tag for resource naming | `string` | `"us"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment Type | `map(string)` | <pre>{<br/>  "Dev": "d",<br/>  "Prod": "p",<br/>  "Test": "t"<br/>}</pre> | no |
| <a name="input_environment_tag"></a> [environment\_tag](#input\_environment\_tag) | {Dev,Test,Prod} Environement Tag | `any` | n/a | yes |
| <a name="input_group_rbac_change_record"></a> [group\_rbac\_change\_record](#input\_group\_rbac\_change\_record) | CHG Record Number for Group | `any` | n/a | yes |
| <a name="input_http_hostname"></a> [http\_hostname](#input\_http\_hostname) | Hostname/Domain of the Application | `string` | `""` | no |
| <a name="input_iam_rbac_group_owner"></a> [iam\_rbac\_group\_owner](#input\_iam\_rbac\_group\_owner) | Owner of the group | `any` | n/a | yes |
| <a name="input_iam_rbac_member_id"></a> [iam\_rbac\_member\_id](#input\_iam\_rbac\_member\_id) | Entra ID User Object ID | `any` | n/a | yes |
| <a name="input_iam_rbac_role"></a> [iam\_rbac\_role](#input\_iam\_rbac\_role) | RBAC role to be assigned to IAM group | `any` | n/a | yes |
| <a name="input_mysql_admin"></a> [mysql\_admin](#input\_mysql\_admin) | MySQL DB Admin Username | `any` | n/a | yes |
| <a name="input_mysql_password"></a> [mysql\_password](#input\_mysql\_password) | MySQL DB Admin Password | `any` | n/a | yes |
| <a name="input_nsg_map_appgw"></a> [nsg\_map\_appgw](#input\_nsg\_map\_appgw) | Map of NSG Rules | <pre>map(object({<br/>    name                    = string<br/>    priority                = string<br/>    direction               = string<br/>    access                  = string<br/>    protocol                = string<br/>    destination_port_range  = string<br/>    source_address_prefixes = list(string)<br/>  }))</pre> | <pre>{<br/>  "4000": {<br/>    "access": "Deny",<br/>    "destination_port_range": "*",<br/>    "direction": "Inbound",<br/>    "name": "DenyInbound",<br/>    "priority": "4000",<br/>    "protocol": "*",<br/>    "source_address_prefixes": [<br/>      "10.0.0.0/8",<br/>      "192.168.0.0/16",<br/>      "172.16.0.0/12"<br/>    ]<br/>  }<br/>}</pre> | no |
| <a name="input_nsg_map_appservice"></a> [nsg\_map\_appservice](#input\_nsg\_map\_appservice) | Map of NSG Rules | <pre>map(object({<br/>    name                    = string<br/>    priority                = string<br/>    direction               = string<br/>    access                  = string<br/>    protocol                = string<br/>    destination_port_range  = string<br/>    source_address_prefixes = list(string)<br/>  }))</pre> | <pre>{<br/>  "4000": {<br/>    "access": "Deny",<br/>    "destination_port_range": "*",<br/>    "direction": "Inbound",<br/>    "name": "DenyInbound",<br/>    "priority": "4000",<br/>    "protocol": "*",<br/>    "source_address_prefixes": [<br/>      "10.0.0.0/8",<br/>      "192.168.0.0/16",<br/>      "172.16.0.0/12"<br/>    ]<br/>  }<br/>}</pre> | no |
| <a name="input_nsg_map_pe"></a> [nsg\_map\_pe](#input\_nsg\_map\_pe) | Map of NSG Rules | <pre>map(object({<br/>    name                    = string<br/>    priority                = string<br/>    direction               = string<br/>    access                  = string<br/>    protocol                = string<br/>    destination_port_range  = string<br/>    source_address_prefixes = list(string)<br/>  }))</pre> | <pre>{<br/>  "4000": {<br/>    "access": "Deny",<br/>    "destination_port_range": "*",<br/>    "direction": "Inbound",<br/>    "name": "DenyInbound",<br/>    "priority": "4000",<br/>    "protocol": "*",<br/>    "source_address_prefixes": [<br/>      "10.0.0.0/8",<br/>      "192.168.0.0/16",<br/>      "172.16.0.0/12"<br/>    ]<br/>  }<br/>}</pre> | no |
| <a name="input_nsg_map_sql"></a> [nsg\_map\_sql](#input\_nsg\_map\_sql) | Map of NSG Rules | <pre>map(object({<br/>    name                    = string<br/>    priority                = string<br/>    direction               = string<br/>    access                  = string<br/>    protocol                = string<br/>    destination_port_range  = string<br/>    source_address_prefixes = list(string)<br/>  }))</pre> | <pre>{<br/>  "4000": {<br/>    "access": "Deny",<br/>    "destination_port_range": "*",<br/>    "direction": "Inbound",<br/>    "name": "DenyInbound",<br/>    "priority": "4000",<br/>    "protocol": "*",<br/>    "source_address_prefixes": [<br/>      "10.0.0.0/8",<br/>      "192.168.0.0/16",<br/>      "172.16.0.0/12"<br/>    ]<br/>  }<br/>}</pre> | no |
| <a name="input_ops_team"></a> [ops\_team](#input\_ops\_team) | Operations Team | `string` | `"Azure Engineering"` | no |
| <a name="input_project_code"></a> [project\_code](#input\_project\_code) | Project Code | `string` | `"n/a"` | no |
| <a name="input_project_tag"></a> [project\_tag](#input\_project\_tag) | Project Tag | `any` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Azure Region | `string` | `"eastus2"` | no |
| <a name="input_service_hours"></a> [service\_hours](#input\_service\_hours) | Application Service Hours | `string` | `"n/a"` | no |
| <a name="input_service_level"></a> [service\_level](#input\_service\_level) | Application Service Level | `string` | `"n/a"` | no |
| <a name="input_snet_subnets"></a> [snet\_subnets](#input\_snet\_subnets) | SNET Subnet CIDRs | `any` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure Subscription ID | `any` | n/a | yes |
| <a name="input_vnet_subnet"></a> [vnet\_subnet](#input\_vnet\_subnet) | VNET Subnet CIDR | `any` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->