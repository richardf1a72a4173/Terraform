resource "azurerm_virtual_network" "us" {
  name                = "vnet${local.resource_template}001"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = local.vnet_snet

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_subnet" "us" {
  name                 = "snet${local.resource_template}001"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.us.name
  address_prefixes     = local.vnet_snet1

  delegation {
    name = "container"
    service_delegation {
      name = "Microsoft.ContainerInstance/containerGroups"
    }
  }
}

resource "azurerm_network_security_group" "us" {
  name                = "nsg${local.resource_template}001"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_subnet_network_security_group_association" "us" {
  subnet_id                 = azurerm_subnet.us.id
  network_security_group_id = azurerm_network_security_group.us.id
}

module "dns_links" {
  source             = "../Modules/DNS-Zone-Links"
  vnet_name          = azurerm_virtual_network.us.name
  virtual_network_id = azurerm_virtual_network.us.id
}

resource "azurerm_subnet" "db" {
  name                 = "snet${local.resource_template}002"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.us.name
  address_prefixes     = local.vnet_snet2

  delegation {
    name = "fs"
    service_delegation {
      name = "Microsoft.DBforMySQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

resource "azurerm_network_security_group" "db" {
  name                = "nsg${local.resource_template}002"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_subnet_network_security_group_association" "db" {
  subnet_id                 = azurerm_subnet.db.id
  network_security_group_id = azurerm_network_security_group.db.id
}

resource "azurerm_network_security_rule" "apprules" {
  for_each = local.nsg_map_app

  name                         = each.value.name
  network_security_group_name  = azurerm_network_security_group.us.name
  resource_group_name          = azurerm_resource_group.rg.name
  priority                     = each.value.priority
  direction                    = each.value.direction
  access                       = each.value.access
  protocol                     = each.value.protocol
  source_port_range            = "*"
  destination_port_range       = each.value.destination_port_range
  source_address_prefixes      = each.value.source_address_prefixes
  destination_address_prefixes = local.vnet_snet1
}

resource "azurerm_network_security_rule" "dbrules" {
  for_each = local.nsg_map_db

  name                         = each.value.name
  network_security_group_name  = azurerm_network_security_group.db.name
  resource_group_name          = azurerm_resource_group.rg.name
  priority                     = each.value.priority
  direction                    = each.value.direction
  access                       = each.value.access
  protocol                     = each.value.protocol
  source_port_range            = "*"
  destination_port_range       = each.value.destination_port_range
  source_address_prefixes      = each.value.source_address_prefixes
  destination_address_prefixes = local.vnet_snet2
}

#Peering for ExpressRoute

resource "azurerm_virtual_hub_connection" "us" {
  provider                  = azurerm.platform
  name                      = "conn-${azurerm_virtual_network.us.name}"
  virtual_hub_id            = data.azurerm_virtual_hub.us.id
  remote_virtual_network_id = azurerm_virtual_network.us.id
}
