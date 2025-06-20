resource "azurerm_virtual_network" "vnet" {
  name                = "vnet${local.resource_template}001"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["fd80:1d03:7761:0::/64"]

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_subnet" "snet" {
  name                 = "snet${local.resource_template}001"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["fd80:1d03:7761:0::/64"]
}
