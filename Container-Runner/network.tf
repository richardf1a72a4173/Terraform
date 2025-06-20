resource "azurerm_virtual_network" "vnet" {
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  name                = "vnet${local.resource_template}001"
  address_space       = var.vnet_subnet
}

resource "azurerm_subnet" "subnet" {
  resource_group_name  = azurerm_resource_group.rg.name
  name                 = "snet${local.resource_template}001"
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.snet_subnets

  delegation {
    name = "container"
    service_delegation {
      name = "Microsoft.ContainerInstance/containerGroups"
    }
  }
}

resource "azurerm_nat_gateway" "nat" {
  name                    = "nat${local.resource_template}001"
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
  name                = "pip${local.resource_template}001"
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
  subnet_id      = azurerm_subnet.subnet.id
  nat_gateway_id = azurerm_nat_gateway.nat.id
}

resource "azurerm_network_security_group" "nsg" {
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  name                = "nsg-snet${local.resource_template}001"

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_network_security_rule" "rules" {
  for_each = var.nsg_map

  name                         = each.value.name
  network_security_group_name  = azurerm_network_security_group.nsg.name
  resource_group_name          = azurerm_resource_group.rg.name
  priority                     = each.value.priority
  direction                    = each.value.direction
  access                       = each.value.access
  protocol                     = each.value.protocol
  source_port_range            = "*"
  destination_port_range       = each.value.destination_port_range
  source_address_prefixes      = each.value.source_address_prefixes
  destination_address_prefixes = azurerm_subnet.subnet.address_prefixes
}

resource "azurerm_subnet_network_security_group_association" "subnet" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
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

#Peering for ExpressRoute

# resource "azurerm_virtual_hub_connection" "us" {
#   provider                  = azurerm.platform
#   name                      = "conn-${azurerm_virtual_network.vnet.name}"
#   virtual_hub_id            = data.azurerm_virtual_hub.us.id
#   remote_virtual_network_id = azurerm_virtual_network.vnet.id
# }
