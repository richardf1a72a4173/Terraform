resource "azurerm_virtual_network" "eu" {
  address_space       = var.region2-vnet
  location            = var.region2
  name                = local.vnet2_name
  resource_group_name = azurerm_resource_group.rg.name

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_subnet" "eu-subnet" {
  count                = 2
  name                 = local.snets2_names[count.index]
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.eu.name
  address_prefixes     = [var.region2-snets[count.index]]

  delegation {
    name = "Microsoft.Network.dnsResolvers"
    service_delegation {
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      name    = "Microsoft.Network/dnsResolvers"
    }
  }
}

resource "azurerm_network_security_group" "eu-nsg" {
  count               = 2
  name                = local.nsg2_names[count.index]
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.region2

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_subnet_network_security_group_association" "eu-nsg" {
  count                     = 2
  network_security_group_id = azurerm_network_security_group.eu-nsg[count.index].id
  subnet_id                 = azurerm_subnet.eu-subnet[count.index].id
}

resource "azurerm_network_security_rule" "eu-rules-ie" {
  for_each = var.nsg_map_eu_ie

  name                         = each.value.name
  network_security_group_name  = azurerm_network_security_group.eu-nsg[0].name
  resource_group_name          = azurerm_resource_group.rg.name
  priority                     = each.value.priority
  direction                    = each.value.direction
  access                       = each.value.access
  protocol                     = each.value.protocol
  source_port_range            = "*"
  destination_port_range       = each.value.destination_port_range
  source_address_prefixes      = each.value.source_address_prefixes
  destination_address_prefixes = azurerm_subnet.eu-subnet[0].address_prefixes

  depends_on = [azurerm_network_security_group.eu-nsg]
}

resource "azurerm_network_security_rule" "eu-rules-oe" {
  for_each = var.nsg_map_eu_oe

  name                         = each.value.name
  network_security_group_name  = azurerm_network_security_group.eu-nsg[1].name
  resource_group_name          = azurerm_resource_group.rg.name
  priority                     = each.value.priority
  direction                    = each.value.direction
  access                       = each.value.access
  protocol                     = each.value.protocol
  source_port_range            = "*"
  destination_port_range       = each.value.destination_port_range
  source_address_prefixes      = each.value.source_address_prefixes
  destination_address_prefixes = azurerm_subnet.eu-subnet[1].address_prefixes

  depends_on = [azurerm_network_security_group.eu-nsg]
}

#Peering for ExpressRoute

resource "azurerm_virtual_hub_connection" "eu" {
  provider                  = azurerm.platform
  name                      = "conn-${azurerm_virtual_network.eu.name}"
  virtual_hub_id            = data.azurerm_virtual_hub.eu.id
  remote_virtual_network_id = azurerm_virtual_network.eu.id
}