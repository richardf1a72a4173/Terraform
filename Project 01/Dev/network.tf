resource "azurerm_virtual_network" "rg" {
  name                = local.vnet_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = local.vnet_snet
  dns_servers = ["10.200.250.4"]
}

resource "azurerm_subnet" "rg" {
  count                = 3
  name                 = element(local.vnet_snet_name, count.index)
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.rg.name
  address_prefixes     = ["${element(local.vnet_snets, count.index)}"]
}

resource "azurerm_application_security_group" "app" {
  name                = local.asg_fe_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_application_security_group" "sql" {
  name                = local.asg_be_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_group" "rg" {
  count               = 2
  name                = element(local.vnet_snet_nsg_name, count.index)
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_rule" "sql" {
  name                                       = "SQL_Inbound"
  network_security_group_name                = local.nsg_by_name["${local.vnet_snet_nsg_name[1]}"].name
  resource_group_name                        = azurerm_resource_group.rg.name
  priority                                   = 200
  direction                                  = "Inbound"
  access                                     = "Allow"
  protocol                                   = "*"
  source_port_range                          = "*"
  destination_port_range                     = "1433-1434"
  source_application_security_group_ids      = ["${azurerm_application_security_group.app.id}"]
  destination_application_security_group_ids = ["${azurerm_application_security_group.sql.id}"]

  depends_on = [azurerm_network_security_group.rg]
}

#Peering for ExpressRoute

resource "azurerm_virtual_hub_connection" "us" {
  provider                  = azurerm.platform
  name                      = "conn-${local.vnet_name}"
  virtual_hub_id            = data.azurerm_virtual_hub.us.id
  remote_virtual_network_id = azurerm_virtual_network.rg.id
}