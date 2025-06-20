# # https://blog.xmi.fr/posts/tls-terraform-azure-lets-encrypt/

# # Creates a private key in PEM format
# resource "tls_private_key" "private_key" {
#   algorithm = "RSA"
# }

# # Creates an account on the ACME server using the private key and an email
# resource "acme_registration" "reg" {
#   account_key_pem = tls_private_key.private_key.private_key_pem
#   email_address   = "richard.@example.tld"
# }

# # As the certificate will be generated in PFX a password is required
# resource "random_password" "cert" {
#   length  = 24
#   special = true
# }

# # Gets a certificate from the ACME server
# resource "acme_certificate" "cert" {
#   account_key_pem          = acme_registration.reg.account_key_pem
#   common_name              = "*.${var.http_hostname}"
#   certificate_p12_password = random_password.cert.result

#   dns_challenge {
#     # Many providers are supported for the DNS challenge, we are using Azure DNS here
#     provider = "azuredns"

#     config = {
#       # Some arguments are passed here but it's not enough to let the provider access the zone in Azure DNS.
#       # Other arguments (tenant id, subscription id, and cient id/secret) must be set through environment variables.
#       AZURE_RESOURCE_GROUP = azurerm_resource_group.rg.name
#       AZURE_ZONE_NAME      = azurerm_dns_zone.ptpscheme.name
#       AZURE_TTL            = 300
#     }
#   }
# }
