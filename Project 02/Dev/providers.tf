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

provider "time" {}

data "azurerm_virtual_hub" "us" {
  provider            = azurerm.platform
  name                = "vwanh-hub-p-us-001"
  resource_group_name = "rg-vwan-p-eu-001"
}

resource "time_static" "time" {}

data "azurerm_dns_zone" "devdns" {
  provider            = azurerm.platform
  name                = "<domain>.net"
  resource_group_name = "rg-certsol-p-us-001"
}

data "azurerm_key_vault_secret" "ssl" {
  name         = "project02-d-us-001-<domain>-net"
  key_vault_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-certsol-p-us-001/providers/Microsoft.KeyVault/vaults/kv-certsol-p-us-001"
}
