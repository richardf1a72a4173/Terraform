resource "azurerm_virtual_network" "vnet" {
  name                = local.vnet_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = [var.vnet_subnet]
  dns_servers         = ["10.200.250.4"]

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_subnet" "app-gw" {
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg.name
  name                 = local.snet_names[0]
  address_prefixes     = [var.snet_subnets[0]]
}

resource "azurerm_subnet" "app" {
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg.name
  name                 = local.snet_names[1]
  address_prefixes     = [var.snet_subnets[1]]

  delegation {
    name = "server"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action",
      "Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

resource "azurerm_subnet" "pe" {
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg.name
  name                 = local.snet_names[2]
  address_prefixes     = [var.snet_subnets[2]]
}

resource "azurerm_subnet" "sql" {
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg.name
  name                 = local.snet_names[3]
  address_prefixes     = [var.snet_subnets[3]]

  delegation {
    name = "sql"
    service_delegation {
      name    = "Microsoft.DBforMySQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "sql-link" {
  provider              = azurerm.platform
  name                  = "pl${local.resource_template}001"
  resource_group_name   = "rg-privatedns-p-us-001"
  private_dns_zone_name = "privatelink.mysql.database.azure.com"
  virtual_network_id    = azurerm_virtual_network.vnet.id

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_network_security_group" "nsg" {
  count               = length(var.snet_subnets)
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  name                = local.nsg_names[count.index]

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_application_security_group" "asg" {
  count               = length(var.snet_subnets)
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  name                = local.asg_names[count.index]

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_network_security_rule" "app-gw-rules" {
  for_each = var.nsg_map_appgw

  name                         = each.value.name
  network_security_group_name  = azurerm_network_security_group.nsg[0].name
  resource_group_name          = azurerm_resource_group.rg.name
  priority                     = each.value.priority
  direction                    = each.value.direction
  access                       = each.value.access
  protocol                     = each.value.protocol
  source_port_range            = "*"
  destination_port_range       = each.value.destination_port_range
  source_address_prefixes      = each.value.source_address_prefixes
  destination_address_prefixes = azurerm_subnet.app-gw.address_prefixes

  depends_on = [azurerm_network_security_group.nsg]
}

resource "azurerm_network_security_rule" "app-service-rules" {
  for_each = var.nsg_map_appservice

  name                         = each.value.name
  network_security_group_name  = azurerm_network_security_group.nsg[1].name
  resource_group_name          = azurerm_resource_group.rg.name
  priority                     = each.value.priority
  direction                    = each.value.direction
  access                       = each.value.access
  protocol                     = each.value.protocol
  source_port_range            = "*"
  destination_port_range       = each.value.destination_port_range
  source_address_prefixes      = each.value.source_address_prefixes
  destination_address_prefixes = azurerm_subnet.app.address_prefixes

  depends_on = [azurerm_network_security_group.nsg]
}

resource "azurerm_network_security_rule" "pe-rules" {
  for_each = var.nsg_map_pe

  name                                       = each.value.name
  network_security_group_name                = azurerm_network_security_group.nsg[2].name
  resource_group_name                        = azurerm_resource_group.rg.name
  priority                                   = each.value.priority
  direction                                  = each.value.direction
  access                                     = each.value.access
  protocol                                   = each.value.protocol
  source_port_range                          = "*"
  destination_port_range                     = each.value.destination_port_range
  source_address_prefixes                    = each.value.source_address_prefixes
  destination_application_security_group_ids = ["${azurerm_application_security_group.asg[2].id}"]

  depends_on = [azurerm_network_security_group.nsg]
}

resource "azurerm_network_security_rule" "sql-rules" {
  for_each = var.nsg_map_sql

  name                         = each.value.name
  network_security_group_name  = azurerm_network_security_group.nsg[3].name
  resource_group_name          = azurerm_resource_group.rg.name
  priority                     = each.value.priority
  direction                    = each.value.direction
  access                       = each.value.access
  protocol                     = each.value.protocol
  source_port_range            = "*"
  destination_port_range       = each.value.destination_port_range
  source_address_prefixes      = each.value.source_address_prefixes
  destination_address_prefixes = azurerm_subnet.sql.address_prefixes

  depends_on = [azurerm_network_security_group.nsg]
}

#Peering for ExpressRoute

resource "azurerm_virtual_hub_connection" "us" {
  provider                  = azurerm.platform
  name                      = "conn-${local.vnet_name}"
  virtual_hub_id            = data.azurerm_virtual_hub.us.id
  remote_virtual_network_id = azurerm_virtual_network.vnet.id
}
