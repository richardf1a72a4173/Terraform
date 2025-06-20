# Providers

provider "azurerm" {
  subscription_id = var.subscription_id
  features {}

  tenant_id     = "00000000-0000-0000-0000-000000000000"
  client_id     = "00000000-0000-0000-0000-000000000000"
  client_secret = var.client_secret
}

data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

provider "time" {}

resource "time_static" "time" {}
