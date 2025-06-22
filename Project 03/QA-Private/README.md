<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.5 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~> 3.4.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 4.29.0 |
| <a name="requirement_http"></a> [http](#requirement\_http) | ~> 3.5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.7.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | ~> 0.13.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | ~> 3.4.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.29.0 |
| <a name="provider_azurerm.platform"></a> [azurerm.platform](#provider\_azurerm.platform) | 4.29.0 |
| <a name="provider_time"></a> [time](#provider\_time) | ~> 0.13.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_application_insights.appins](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/application_insights) | resource |
| [azurerm_application_security_group.app](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/application_security_group) | resource |
| [azurerm_application_security_group.sql](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/application_security_group) | resource |
| [azurerm_cdn_frontdoor_custom_domain.test](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/cdn_frontdoor_custom_domain) | resource |
| [azurerm_cdn_frontdoor_custom_domain_association.test](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/cdn_frontdoor_custom_domain_association) | resource |
| [azurerm_cdn_frontdoor_endpoint.endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/cdn_frontdoor_endpoint) | resource |
| [azurerm_cdn_frontdoor_firewall_policy.firewall](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/cdn_frontdoor_firewall_policy) | resource |
| [azurerm_cdn_frontdoor_origin.test](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/cdn_frontdoor_origin) | resource |
| [azurerm_cdn_frontdoor_origin_group.test](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/cdn_frontdoor_origin_group) | resource |
| [azurerm_cdn_frontdoor_profile.afd](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/cdn_frontdoor_profile) | resource |
| [azurerm_cdn_frontdoor_route.route](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/cdn_frontdoor_route) | resource |
| [azurerm_cdn_frontdoor_rule_set.test](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/cdn_frontdoor_rule_set) | resource |
| [azurerm_cdn_frontdoor_security_policy.waf](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/cdn_frontdoor_security_policy) | resource |
| [azurerm_dns_a_record.test](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/dns_a_record) | resource |
| [azurerm_dns_txt_record.validation](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/dns_txt_record) | resource |
| [azurerm_mssql_database.us](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/mssql_database) | resource |
| [azurerm_mssql_server.us](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/mssql_server) | resource |
| [azurerm_network_security_group.us](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.app](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.app-inbound](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.app-outbound](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.dev-sql-inbound](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.sql](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.sql-inbound](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/network_security_rule) | resource |
| [azurerm_private_dns_zone_virtual_network_link.links](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_endpoint.app](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.ds1](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.ds2](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.sa](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint.sql](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/private_endpoint) | resource |
| [azurerm_private_endpoint_application_security_group_association.app](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/private_endpoint_application_security_group_association) | resource |
| [azurerm_private_endpoint_application_security_group_association.sa](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/private_endpoint_application_security_group_association) | resource |
| [azurerm_private_endpoint_application_security_group_association.sql](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/private_endpoint_application_security_group_association) | resource |
| [azurerm_resource_group.us](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.us](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/role_assignment) | resource |
| [azurerm_service_plan.us](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/service_plan) | resource |
| [azurerm_storage_account.us](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/storage_account) | resource |
| [azurerm_storage_container.container](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/storage_container) | resource |
| [azurerm_subnet.us](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/subnet) | resource |
| [azurerm_subnet_network_security_group_association.us](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_virtual_hub_connection.us](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/virtual_hub_connection) | resource |
| [azurerm_virtual_network.us](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/virtual_network) | resource |
| [azurerm_windows_web_app.us](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/windows_web_app) | resource |
| [azurerm_windows_web_app_slot.slot1](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/windows_web_app_slot) | resource |
| [azurerm_windows_web_app_slot.slot2](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/resources/windows_web_app_slot) | resource |
| [time_static.time](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static) | resource |
| [azuread_client_config.current](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/client_config) | data source |
| [azurerm_dns_zone.devdns](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/data-sources/dns_zone) | data source |
| [azurerm_virtual_hub.us](https://registry.terraform.io/providers/hashicorp/azurerm/4.29.0/docs/data-sources/virtual_hub) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ad"></a> [ad](#input\_ad) | Active Directory | `string` | `"n/a"` | no |
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | Application Name | `string` | `"n/a"` | no |
| <a name="input_client_certificate_password"></a> [client\_certificate\_password](#input\_client\_certificate\_password) | SPN Client Certificate Password | `string` | `""` | no |
| <a name="input_client_certificate_path"></a> [client\_certificate\_path](#input\_client\_certificate\_path) | SPN Client Certificate Path | `string` | `""` | no |
| <a name="input_confidentiality"></a> [confidentiality](#input\_confidentiality) | Confidentiality | `string` | `"n/a"` | no |
| <a name="input_cost_centre"></a> [cost\_centre](#input\_cost\_centre) | Cost Centre | `string` | `"n/a"` | no |
| <a name="input_country_tag"></a> [country\_tag](#input\_country\_tag) | {us,eu} Country Tag for resource naming | `string` | `"us"` | no |
| <a name="input_dns_zones"></a> [dns\_zones](#input\_dns\_zones) | The Private DNS Zones to be linked | <pre>map(object({<br/>    short_name = string<br/>    name       = string<br/>  }))</pre> | <pre>{<br/>  "acr": {<br/>    "name": "privatelink.azurecr.io",<br/>    "short_name": "acr"<br/>  },<br/>  "azurewebsites": {<br/>    "name": "privatelink.azurewebsites.net",<br/>    "short_name": "azurewebsites"<br/>  },<br/>  "blob": {<br/>    "name": "privatelink.blob.core.windows.net",<br/>    "short_name": "blob"<br/>  },<br/>  "database": {<br/>    "name": "privatelink.database.windows.net",<br/>    "short_name": "database"<br/>  },<br/>  "file": {<br/>    "name": "privatelink.file.core.windows.net",<br/>    "short_name": "file"<br/>  },<br/>  "mysql": {<br/>    "name": "privatelink.mysql.database.azure.com",<br/>    "short_name": "mysql"<br/>  },<br/>  "redis": {<br/>    "name": "privatelink.redis.cache.windows.net",<br/>    "short_name": "redis"<br/>  },<br/>  "servicebus": {<br/>    "name": "privatelink.servicebus.windows.net",<br/>    "short_name": "servicebus"<br/>  },<br/>  "vaultcore": {<br/>    "name": "privatelink.vaultcore.azure.net",<br/>    "short_name": "vaultcore"<br/>  }<br/>}</pre> | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment Type | `map(string)` | <pre>{<br/>  "Dev": "d",<br/>  "Prod": "p",<br/>  "Test": "t"<br/>}</pre> | no |
| <a name="input_environment_tag"></a> [environment\_tag](#input\_environment\_tag) | {Dev,Test,Prod} Environement Tag | `string` | n/a | yes |
| <a name="input_ops_team"></a> [ops\_team](#input\_ops\_team) | Operations Team | `string` | `"Azure Engineering"` | no |
| <a name="input_project_code"></a> [project\_code](#input\_project\_code) | Project Code | `string` | `"n/a"` | no |
| <a name="input_project_tag"></a> [project\_tag](#input\_project\_tag) | Project Tag | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Azure Region | `string` | `"eastus2"` | no |
| <a name="input_rg_reader_principal"></a> [rg\_reader\_principal](#input\_rg\_reader\_principal) | Resource Group Reader Principal | `string` | n/a | yes |
| <a name="input_service_hours"></a> [service\_hours](#input\_service\_hours) | Application Service Hours | `string` | `"n/a"` | no |
| <a name="input_service_level"></a> [service\_level](#input\_service\_level) | Application Service Level | `string` | `"n/a"` | no |
| <a name="input_sql_login_object_id"></a> [sql\_login\_object\_id](#input\_sql\_login\_object\_id) | SQL Login Object ID | `string` | n/a | yes |
| <a name="input_sql_login_username"></a> [sql\_login\_username](#input\_sql\_login\_username) | SQL Login Username | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure Subscription ID | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->