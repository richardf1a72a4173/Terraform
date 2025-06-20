# https://learn.microsoft.com/en-us/azure/active-directory-b2c/custom-domain?pivots=b2c-user-flow

# resource "azurerm_user_assigned_identity" "cdnkv" {
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name
#   name                = "uai${local.resource_template}001"
# }

# module "avm-res-cdn-profile" {
#   source  = "Azure/avm-res-cdn-profile/azurerm"
#   version = "0.1.2"

#   enable_telemetry = false

#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location

#   name = "afd${local.resource_template}001"
#   sku  = "Standard_AzureFrontDoor"

#   managed_identities = {
#     system_assigned = true
#     user_assigned_resource_ids = [
#       azurerm_user_assigned_identity.cdnkv.id
#     ]
#   }

#   front_door_origin_groups = {
#     og_key = {
#       name = "cdn-og${local.resource_template}001"
#       health_probe = {
#         hp1 = {
#           interval_in_seconds = 240
#           path                = "/"
#           protocol            = "Https"
#           request_type        = "HEAD"
#         }
#       }
#       load_balancing = {
#         lb = {
#           additional_latency_in_milliseconds = 0
#           sample_size                        = 16
#           successful_samples_required        = 3
#         }
#       }
#     }
#   }

#   front_door_origins = {
#     origin = {
#       name                           = "origin"
#       origin_group_key               = "og_key"
#       enabled                        = true
#       certificate_name_check_enabled = false
#       host_name                      = local.app_hostname
#       http_port                      = 80
#       https_port                     = 443
#       host_header                    = "login.${local.app_hostname}"
#       priority                       = 1
#       weight                         = 1
#     }
#   }

#   front_door_endpoints = {
#     endpoint = {
#       name = "cdn-ep${local.resource_template}001"
#     }
#   }

#   front_door_secrets = {
#     secret_key = {
#       name                     = "cert-login${local.resource_template}001"
#       key_vault_certificate_id = data.azurerm_key_vault_secret.cdn.id
#     }
#   }

#   front_door_custom_domains = {
#     login = {
#       name        = "login${local.resource_template}001"
#       dns_zone_id = data.azurerm_dns_zone.devdns.id
#       host_name   = "login.${local.app_hostname}"

#       tls = {
#         certificate_type         = "CustomerCertificate"
#         minimum_tls_version      = "TLS12"
#         cdn_frontdoor_secret_key = "secret_key"
#       }
#     }
#   }
# }

# resource "azurerm_cdn_frontdoor_profile" "afd" {
#   name                = "afd${local.resource_template}001"
#   resource_group_name = azurerm_resource_group.rg.name
#   sku_name            = "Standard_AzureFrontDoor"
# }

# import {
#   id = ""
#   to = azurerm_cdn_frontdoor_custom_domain.afd
# }

# import {
#   id = ""
#   to = 
# }

# resource "azurerm_cdn_frontdoor_secret" "afd" {
#   name                     = "login-ptpirr-d-s-eu-001-qb3rh6ep9j-net"
#   cdn_frontdoor_profile_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ptpirr-d-s-eu-001/providers/Microsoft.Cdn/profiles/afd-ptpirr-d-s-eu-001"

#   secret {
#     customer_certificate {
#       key_vault_certificate_id = data.azurerm_key_vault_secret.cdn.id
#     }
#   }
# }
