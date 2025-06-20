# module "appservice_domain" {
#   source = "HoussemDellai/appservice-domain/azapi"

#   providers = {
#     azapi = azapi
#   }

#   custom_domain_name = var.domain_name
#   resource_group_id  = azurerm_resource_group.rg.id
#   dns_zone_id        = azurerm_dns_zone.dns.id

#   contact = {
#     nameFirst = "Richard"
#     nameLast  = ""
#     email     = ""
#     phone     = ""
#     addressMailing = {
#       address1   = ""
#       city       = "London"
#       state      = "London"
#       country    = "UK"
#       postalCode = ""
#     }
#   }
# }
