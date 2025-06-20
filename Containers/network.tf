resource "azurerm_virtual_network" "vnet" {
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  name                = local.vnet_name
  address_space       = local.vnet_address
}

resource "azurerm_subnet" "subnet" {
  resource_group_name  = azurerm_resource_group.rg.name
  name                 = local.snet_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = local.snet_address

  delegation {
    name = "container"
    service_delegation {
      name = "Microsoft.ContainerInstance/containerGroups"
    }
  }
}