# Providers

provider "azurerm" {
  subscription_id = var.subscription_id
  features {}
}

data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

#VWAN Hub Provider
provider "azurerm" {
  alias           = "platform"
  subscription_id = "00000000-0000-0000-0000-000000000000"
  features {}
}

data "azurerm_virtual_hub" "us" {
  provider            = azurerm.platform
  name                = "vwanh-hub-p-us-001"
  resource_group_name = "rg-vwan-p-eu-001"
}

provider "azuread" {
  tenant_id = "00000000-0000-0000-0000-000000000000"
  alias     = "entraid"
}

data "http" "myip" {
  url = "https://ifconfig.me/ip"
}

provider "time" {}

resource "time_static" "time" {}

data "azuread_group" "rbac_group" {
  object_id = var.rbac_group_object_id
}
