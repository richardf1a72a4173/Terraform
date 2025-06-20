resource "azurerm_virtual_network" "vnet" {
  address_space       = ["10.200.150.0/24"]
  location            = azurerm_resource_group.this.location
  name                = "private-vnet"
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_subnet" "subnet" {
  address_prefixes     = ["10.200.150.0/26"]
  name                 = "default"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.vnet.name
}

resource "azurerm_subnet" "unp1_subnet" {
  address_prefixes     = ["10.200.150.64/26"]
  name                 = "unp1"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.vnet.name
}

resource "azurerm_subnet" "unp2_subnet" {
  address_prefixes     = ["10.200.150.128/26"]
  name                 = "unp2"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.vnet.name
}

resource "azurerm_subnet" "mgmt" {
  address_prefixes     = ["10.200.150.192/26"]
  name                 = "mgmt"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.vnet.name
}

#DNS Links

resource "azurerm_private_dns_zone_virtual_network_link" "links" {
  provider = azurerm.platform
  for_each = var.dns_zones

  name                  = "pl-${each.value.short_name}-${azurerm_virtual_network.vnet.name}"
  resource_group_name   = "rg-privatedns-p-us-001"
  private_dns_zone_name = each.value.name
  virtual_network_id    = azurerm_virtual_network.vnet.id

  lifecycle {
    ignore_changes = [tags]
  }
}
