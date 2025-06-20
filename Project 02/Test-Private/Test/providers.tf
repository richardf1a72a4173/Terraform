# Providers

provider "azurerm" {
  subscription_id = var.subscription_id
  features {}

  client_id = "00000000-0000-0000-0000-000000000000" # spn-c-t0.richard.-var
  # client_secret = var.client_secret
  client_certificate_path     = var.client_certificate_path
  client_certificate_password = var.client_certificate_password
  tenant_id                   = "00000000-0000-0000-0000-000000000000"
}

data "azurerm_client_config" "current" {}

#VWAN Hub Provider
provider "azurerm" {
  alias           = "platform"
  subscription_id = "00000000-0000-0000-0000-000000000000" # Platform
  features {}

  client_id = "00000000-0000-0000-0000-000000000000" # spn-c-t0.richard.-var
  # client_secret = var.client_secret
  client_certificate_path     = var.client_certificate_path
  client_certificate_password = var.client_certificate_password
  tenant_id                   = "00000000-0000-0000-0000-000000000000"
}

provider "azuread" {
  client_id = "00000000-0000-0000-0000-000000000000" # spn-c-t0.richard.-var
  # client_secret = var.client_secret
  client_certificate_path     = var.client_certificate_path
  client_certificate_password = var.client_certificate_password
  tenant_id                   = "00000000-0000-0000-0000-000000000000"
}

provider "time" {}

data "http" "myip" {
  url = "https://ipinfo.io/ip"
}

data "azurerm_virtual_hub" "eu" {
  provider            = azurerm.platform
  name                = "vwanh-hub-p-eu-001"
  resource_group_name = "rg-vwan-p-eu-001"
}

resource "time_static" "time" {}

data "azurerm_cdn_frontdoor_endpoint" "endpoint" {
  name                = "afd-endpoint-ptpirr-t-s-eu-001"
  resource_group_name = "rg-ptpirr-t-s-eu-002"
  profile_name        = "afd-ptpirr-t-s-eu-001"
}

data "azurerm_public_ip" "pip" {
  name                = azurerm_public_ip.pip.name
  resource_group_name = azurerm_resource_group.rg.name
}

data "azurerm_dns_zone" "devdns" {
  provider            = azurerm.platform
  name                = "qb3rh6ep9j.net"
  resource_group_name = "rg-certsol-p-us-001"
}

data "azurerm_key_vault" "certs" {
  provider            = azurerm.platform
  name                = "kv-certsol-p-us-001"
  resource_group_name = "rg-certsol-p-us-001"
}

data "azurerm_key_vault_secret" "ssl" {
  provider     = azurerm.platform
  name         = "ptpirr-t-s-eu-001-qb3rh6ep9j-net"
  key_vault_id = data.azurerm_key_vault.certs.id
}

data "azurerm_key_vault_secret" "ssl2" {
  provider     = azurerm.platform
  name         = "ptpirr-t-s-eu-002-qb3rh6ep9j-net"
  key_vault_id = data.azurerm_key_vault.certs.id
}
