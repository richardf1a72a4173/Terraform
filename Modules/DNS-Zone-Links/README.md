provider "azurerm" {
  alias           = "platform"
  subscription_id = "00000000-0000-0000-0000-000000000000"
  features {}
}

module "dns_links" {
  source = "../../../Modules/DNS-Zone-Links"
  providers = {
    azurerm = azurerm.platform
  }

  vnet_name          = azurerm_virtual_network.vnet.name
  virtual_network_id = azurerm_virtual_network.vnet.id
}