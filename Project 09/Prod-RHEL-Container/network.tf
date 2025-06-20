resource "azurerm_virtual_network" "vnet" {
  name                = "vnet${local.resource_template}001"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = [var.vnet_subnet]

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_subnet" "app-gw" {
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg.name
  name                 = "snet${local.resource_template}001"
  address_prefixes     = [var.snet_subnets[0]]
}

resource "azurerm_subnet" "app" {
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg.name
  name                 = "snet${local.resource_template}002"
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
  name                 = "snet${local.resource_template}003"
  address_prefixes     = [var.snet_subnets[2]]
}

resource "azurerm_subnet" "sql" {
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg.name
  name                 = "snet${local.resource_template}004"
  address_prefixes     = [var.snet_subnets[3]]

  delegation {
    name = "sql"
    service_delegation {
      name    = "Microsoft.DBforMySQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

resource "azurerm_subnet" "redis" {
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg.name
  name                 = "snet${local.resource_template}006"
  address_prefixes     = [var.snet_subnets[4]]

  #   delegation {
  #     name = "container"
  #     service_delegation {
  #       name = "Microsoft.ContainerInstance/containerGroups"
  #     }
  #   }
}

resource "azurerm_network_security_group" "nsg" {
  count               = length(var.snet_subnets)
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  name                = "nsg${local.resource_template}00${count.index + 1}"

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_application_security_group" "asg" {
  count               = length(var.snet_subnets)
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  name                = "asg${local.resource_template}00${count.index + 1}"

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_network_security_rule" "appgw-clients" {
  name                         = "AppGatewayInbound"
  network_security_group_name  = azurerm_network_security_group.nsg[0].name
  resource_group_name          = azurerm_resource_group.rg.name
  priority                     = "300"
  direction                    = "Inbound"
  access                       = "Allow"
  protocol                     = "*"
  source_port_range            = "*"
  source_address_prefix        = "${data.http.myip.body}/32"
  destination_port_ranges      = ["80", "443"]
  destination_address_prefixes = azurerm_subnet.app-gw.address_prefixes

  depends_on = [azurerm_network_security_group.nsg]
}

resource "azurerm_network_security_rule" "appgw-gateway" {
  name                        = "AppGatewayGatewayManager"
  network_security_group_name = azurerm_network_security_group.nsg[0].name
  resource_group_name         = azurerm_resource_group.rg.name
  priority                    = "310"
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  source_address_prefix       = "GatewayManager"
  destination_port_range      = "65200-65535"
  destination_address_prefix  = "*"

  depends_on = [azurerm_network_security_group.nsg]
}

resource "azurerm_network_security_rule" "appgw-loadbalancer" {
  name                        = "AppGatewayLoadBalancer"
  network_security_group_name = azurerm_network_security_group.nsg[0].name
  resource_group_name         = azurerm_resource_group.rg.name
  priority                    = "320"
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  source_address_prefix       = "AzureLoadBalancer"
  destination_port_range      = "443"
  destination_address_prefix  = "*"

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

resource "azurerm_subnet_network_security_group_association" "app" {
  subnet_id                 = azurerm_subnet.app.id
  network_security_group_id = azurerm_network_security_group.nsg[1].id
}

resource "azurerm_subnet_network_security_group_association" "app-gw" {
  subnet_id                 = azurerm_subnet.app-gw.id
  network_security_group_id = azurerm_network_security_group.nsg[0].id
}

resource "azurerm_subnet_network_security_group_association" "pe" {
  subnet_id                 = azurerm_subnet.pe.id
  network_security_group_id = azurerm_network_security_group.nsg[2].id
}

resource "azurerm_subnet_network_security_group_association" "sql" {
  subnet_id                 = azurerm_subnet.sql.id
  network_security_group_id = azurerm_network_security_group.nsg[3].id
}

resource "azurerm_subnet_network_security_group_association" "redis" {
  subnet_id                 = azurerm_subnet.redis.id
  network_security_group_id = azurerm_network_security_group.nsg[4].id
}

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
