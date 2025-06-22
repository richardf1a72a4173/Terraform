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
| [azurerm_private_dns_zone_virtual_network_link.links](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dns_zones"></a> [dns\_zones](#input\_dns\_zones) | The Private DNS Zones to be linked | <pre>map(object({<br/>    short_name = string<br/>    name       = string<br/>  }))</pre> | <pre>{<br/>  "acr": {<br/>    "name": "privatelink.azurecr.io",<br/>    "short_name": "acr"<br/>  },<br/>  "azurewebsites": {<br/>    "name": "privatelink.azurewebsites.net",<br/>    "short_name": "azurewebsites"<br/>  },<br/>  "blob": {<br/>    "name": "privatelink.blob.core.windows.net",<br/>    "short_name": "blob"<br/>  },<br/>  "configuration": {<br/>    "name": "privatelink.azconfig.io",<br/>    "short_name": "configuration"<br/>  },<br/>  "database": {<br/>    "name": "privatelink.database.windows.net",<br/>    "short_name": "database"<br/>  },<br/>  "file": {<br/>    "name": "privatelink.file.core.windows.net",<br/>    "short_name": "file"<br/>  },<br/>  "mysql": {<br/>    "name": "privatelink.mysql.database.azure.com",<br/>    "short_name": "mysql"<br/>  },<br/>  "redis": {<br/>    "name": "privatelink.redis.cache.windows.net",<br/>    "short_name": "redis"<br/>  },<br/>  "servicebus": {<br/>    "name": "privatelink.servicebus.windows.net",<br/>    "short_name": "servicebus"<br/>  },<br/>  "vaultcore": {<br/>    "name": "privatelink.vaultcore.azure.net",<br/>    "short_name": "vaultcore"<br/>  }<br/>}</pre> | no |
| <a name="input_private_dns_zone_rg_name"></a> [private\_dns\_zone\_rg\_name](#input\_private\_dns\_zone\_rg\_name) | The private DNS zone resource group | `string` | `"rg-privatedns-p-us-001"` | no |
| <a name="input_virtual_network_id"></a> [virtual\_network\_id](#input\_virtual\_network\_id) | The VNET ID of your VNET | `string` | n/a | yes |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | The name of your VNET being linked | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->