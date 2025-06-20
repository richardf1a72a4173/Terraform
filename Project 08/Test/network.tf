resource "azurerm_virtual_network" "vnet" {
  name                = module.naming.virtual_network.name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = [var.vnet_subnet]

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_subnet" "snets" {
  count = length(var.snet_subnets)

  name                 = "${module.naming.subnet.name}-00${count.index + 1}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.snet_subnets[count.index]]
  service_endpoints    = ["Microsoft.KeyVault", "Microsoft.ServiceBus", "Microsoft.Storage"]

  dynamic "delegation" {
    for_each = count.index == 2 ? [1] : []

    content {
      name = "server"
      service_delegation {
        name = "Microsoft.Web/serverFarms"
        actions = [
          "Microsoft.Network/virtualNetworks/subnets/action",
          "Microsoft.Network/virtualNetworks/subnets/join/action"
        ]
      }
    }
  }
}

resource "azurerm_network_security_group" "nsgs" {
  count = length(azurerm_subnet.snets)

  name                = "${module.naming.network_security_group.name}-00${count.index + 1}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg" {
  count = length(azurerm_network_security_group.nsgs)

  subnet_id                 = azurerm_subnet.snets[count.index].id
  network_security_group_id = azurerm_network_security_group.nsgs[count.index].id
}

resource "azurerm_network_security_rule" "appgw-clients" {
  name                        = "AppGatewayInbound"
  network_security_group_name = azurerm_network_security_group.nsgs[0].name
  resource_group_name         = azurerm_resource_group.rg.name
  priority                    = "300"
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  source_address_prefixes = setunion([
    "${data.azurerm_public_ip.pip.ip_address}/32",
    "${data.http.myip.response_body}/32",
    "212.38.169.64/27", # Pen Test Partners
    "78.129.217.224/27",
    "91.238.238.0/25",
    "91.238.238.128/27",
    "91.238.238.160/27",
    "91.238.238.192/27",
    "217.39.246.94/32"],
    var.dev_ips, # James Morel
  var.api_access_ips)
  destination_port_ranges      = ["80", "443"]
  destination_address_prefixes = concat(azurerm_subnet.snets[0].address_prefixes, ["${data.azurerm_public_ip.pip.ip_address}/32"])
}

resource "azurerm_network_security_rule" "appgw-gateway" {
  name                        = "AppGatewayGatewayManager"
  network_security_group_name = azurerm_network_security_group.nsgs[0].name
  resource_group_name         = azurerm_resource_group.rg.name
  priority                    = "310"
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  source_address_prefix       = "GatewayManager"
  destination_port_range      = "65200-65535"
  destination_address_prefix  = "*"
}

resource "azurerm_network_security_rule" "appgw-loadbalancer" {
  name                        = "AppGatewayLoadBalancer"
  network_security_group_name = azurerm_network_security_group.nsgs[0].name
  resource_group_name         = azurerm_resource_group.rg.name
  priority                    = "320"
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  source_address_prefix       = "AzureLoadBalancer"
  destination_port_range      = "443"
  destination_address_prefix  = "*"
}

resource "azurerm_network_security_rule" "pe" {
  for_each = var.nsg_map_pe

  name                         = each.value.name
  network_security_group_name  = azurerm_network_security_group.nsgs[1].name
  resource_group_name          = azurerm_resource_group.rg.name
  priority                     = each.value.priority
  direction                    = each.value.direction
  access                       = each.value.access
  protocol                     = each.value.protocol
  source_port_range            = "*"
  destination_port_range       = each.value.destination_port_range
  source_address_prefixes      = each.value.source_address_prefixes
  destination_address_prefixes = azurerm_subnet.snets[1].address_prefixes
}

resource "azurerm_network_security_rule" "default" {
  count = length(azurerm_network_security_group.nsgs)

  name                         = var.nsg_map[4000].name
  network_security_group_name  = azurerm_network_security_group.nsgs[count.index].name
  resource_group_name          = azurerm_resource_group.rg.name
  priority                     = var.nsg_map[4000].priority
  direction                    = var.nsg_map[4000].direction
  access                       = var.nsg_map[4000].access
  protocol                     = var.nsg_map[4000].protocol
  source_port_range            = "*"
  destination_port_range       = var.nsg_map[4000].destination_port_range
  source_address_prefixes      = var.nsg_map[4000].source_address_prefixes
  destination_address_prefixes = azurerm_subnet.snets[count.index].address_prefixes
}

# DNS Links

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

resource "azurerm_virtual_hub_connection" "us" {
  provider                  = azurerm.platform
  name                      = "conn-${azurerm_virtual_network.vnet.name}"
  virtual_hub_id            = data.azurerm_virtual_hub.us.id
  remote_virtual_network_id = azurerm_virtual_network.vnet.id
}
