resource "azurerm_virtual_network" "us" {
  name                = local.vnet_name
  location            = azurerm_resource_group.us.location
  resource_group_name = azurerm_resource_group.us.name
  address_space       = local.vnet_snet
  dns_servers = ["10.200.250.4"]
}

resource "azurerm_subnet" "us" {
  name                 = local.vnet_snet_name
  resource_group_name  = azurerm_resource_group.us.name
  virtual_network_name = azurerm_virtual_network.us.name
  address_prefixes     = local.vnet_snets
}

resource "azurerm_application_security_group" "sql" {
  name                = local.asg_be_name
  location            = azurerm_resource_group.us.location
  resource_group_name = azurerm_resource_group.us.name
}

resource "azurerm_network_security_group" "us" {
  name                = local.vnet_snet_nsg_name
  location            = azurerm_resource_group.us.location
  resource_group_name = azurerm_resource_group.us.name
}

resource "azurerm_network_security_rule" "sql" {
  name                       = "DenyInbound"
  priority                   = 4000
  direction                  = "Inbound"
  access                     = "Deny"
  protocol                   = "*"
  source_port_range          = "*"
  destination_port_range     = "*"
  source_address_prefixes    = ["10.0.0.0/8", "192.168.0.0/16", "172.16.0.0/12"]
  destination_address_prefix = "*"

  resource_group_name         = azurerm_resource_group.us.name
  network_security_group_name = azurerm_network_security_group.us.name
}

resource "azurerm_network_security_rule" "sql-inbound" {
  name                                       = "SQLInbound"
  priority                                   = 200
  direction                                  = "Inbound"
  access                                     = "Allow"
  protocol                                   = "*"
  source_port_range                          = "*"
  destination_port_range                     = "1433-1434"
  source_address_prefixes                    = ["10.0.0.0/8", "192.168.0.0/16", "172.16.0.0/12"]
  destination_application_security_group_ids = ["${azurerm_application_security_group.sql.id}"]

  resource_group_name         = azurerm_resource_group.us.name
  network_security_group_name = azurerm_network_security_group.us.name
}

resource "azurerm_subnet_network_security_group_association" "us" {
  subnet_id                 = azurerm_subnet.us.id
  network_security_group_id = azurerm_network_security_group.us.id
}

# ASG Association

resource "azurerm_private_endpoint_application_security_group_association" "sql" {
  private_endpoint_id           = azurerm_private_endpoint.sql.id
  application_security_group_id = azurerm_application_security_group.sql.id
}

#Peering for ExpressRoute

resource "azurerm_virtual_hub_connection" "us" {
  provider                  = azurerm.platform
  name                      = "conn-${local.vnet_name}"
  virtual_hub_id            = data.azurerm_virtual_hub.us.id
  remote_virtual_network_id = azurerm_virtual_network.us.id
}