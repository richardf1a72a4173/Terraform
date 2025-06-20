# Providers

provider "azurerm" {
  subscription_id = var.subscription_id
  features {}

  tenant_id = "00000000-0000-0000-0000-000000000000"
}

data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

#VWAN Hub Provider
provider "azurerm" {
  alias           = "platform"
  subscription_id = "00000000-0000-0000-0000-000000000000"
  features {}

  tenant_id = "00000000-0000-0000-0000-000000000000"
}

provider "azuread" {

  tenant_id = "00000000-0000-0000-0000-000000000000"
}

provider "time" {}

data "azurerm_virtual_hub" "us" {
  provider            = azurerm.platform
  name                = "vwanh-hub-p-us-001"
  resource_group_name = "rg-vwan-p-eu-001"
}

resource "time_static" "time" {}
