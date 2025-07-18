# Providers

provider "azurerm" {
  subscription_id = var.subscription_id
  features {}

  client_id = "00000000-0000-0000-0000-000000000000"
  # client_secret = var.client_secret
  client_certificate_path     = var.client_certificate_path
  client_certificate_password = var.client_certificate_password
  tenant_id                   = "00000000-0000-0000-0000-000000000000"
}

data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

#VWAN Hub Provider
provider "azurerm" {
  alias           = "platform"
  subscription_id = "00000000-0000-0000-0000-000000000000"
  features {}

  client_id = "00000000-0000-0000-0000-000000000000"
  # client_secret = var.client_secret
  client_certificate_path     = var.client_certificate_path
  client_certificate_password = var.client_certificate_password
  tenant_id                   = "00000000-0000-0000-0000-000000000000"
}

provider "azuread" {
  client_id = "00000000-0000-0000-0000-000000000000"
  # client_secret = var.client_secret
  client_certificate_path     = var.client_certificate_path
  client_certificate_password = var.client_certificate_password
  tenant_id                   = "00000000-0000-0000-0000-000000000000"
}

provider "time" {}

data "azurerm_virtual_hub" "us" {
  provider            = azurerm.platform
  name                = "vwanh-hub-p-us-001"
  resource_group_name = "rg-vwan-p-eu-001"
}

resource "time_static" "time" {}
