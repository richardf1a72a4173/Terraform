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
  subscription_id = "00000000-0000-0000-0000-000000000000" # Platform
  features {}
}

provider "time" {}

data "azurerm_virtual_hub" "us" {
  provider            = azurerm.platform
  name                = "vwanh-hub-p-us-001"
  resource_group_name = "rg-vwan-p-eu-001"
}

resource "time_static" "time" {}

provider "docker" {
  host = "https://${data.azurerm_container_registry.myacr.login_server}"
  registry_auth {
    address  = data.azurerm_container_registry.myacr.login_server
    username = data.azurerm_container_registry.myacr.admin_username
    password = data.azurerm_container_registry.myacr.admin_password
  }
}

data "azurerm_container_registry" "myacr" {
  name                = "acr${local.safe_basename}001"
  resource_group_name = azurerm_resource_group.rg.name
}

data "http" "myip" {
  url = "https://ifconfig.me/ip"
}
