resource "azurerm_virtual_network" "vnet" {
  name                = module.naming.virtual_network.name_unique
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["fd80:1d03:7761:0::/64", "172.31.201.0/24"]

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_subnet" "snet" {
  name                 = module.naming.subnet.name_unique
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["fd80:1d03:7761:0::/64", "172.31.201.0/24"]
}

resource "azurerm_nat_gateway" "nat" {
  name                    = module.naming.nat_gateway.name_unique
  location                = azurerm_resource_group.rg.location
  resource_group_name     = azurerm_resource_group.rg.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  zones                   = azurerm_public_ip.nat.zones

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_public_ip" "nat" {
  name                = module.naming.public_ip.name_unique
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_nat_gateway_public_ip_association" "nat" {
  nat_gateway_id       = azurerm_nat_gateway.nat.id
  public_ip_address_id = azurerm_public_ip.nat.id
}

resource "azurerm_subnet_nat_gateway_association" "nat" {
  nat_gateway_id = azurerm_nat_gateway.nat.id
  subnet_id      = azurerm_subnet.snet.id
}

resource "azurerm_network_security_group" "rg" {
  name                = module.naming.network_security_group.name_unique
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}
