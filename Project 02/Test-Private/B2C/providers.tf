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

#B2C Creator
provider "azurerm" {
  alias           = "b2c"
  subscription_id = var.subscription_id
  features {}
}

provider "time" {}

resource "time_static" "time" {}

data "azurerm_dns_zone" "devdns" {
  provider            = azurerm.platform
  name                = "qb3rh6ep9j.net"
  resource_group_name = "rg-certsol-p-us-001"
}
