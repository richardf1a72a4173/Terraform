resource "azurerm_virtual_network" "this" {
  name                = module.naming.virtual_network.name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  address_space       = [var.vnet_subnet]
}

resource "azurerm_subnet" "this" {
  name                 = module.naming.subnet.name
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = var.snet_subnets
}
