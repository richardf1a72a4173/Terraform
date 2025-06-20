resource "azurerm_virtual_network" "us" {
  name                = local.vnet_name
  location            = azurerm_resource_group.us.location
  resource_group_name = azurerm_resource_group.us.name
  address_space       = var.vnet_snet

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_subnet" "us" {
  name                 = local.vnet_snet_name
  resource_group_name  = azurerm_resource_group.us.name
  virtual_network_name = azurerm_virtual_network.us.name
  address_prefixes     = var.vnet_snets
}

resource "azurerm_application_security_group" "sql" {
  name                = "asg-sql${local.resource_template}001"
  location            = azurerm_resource_group.us.location
  resource_group_name = azurerm_resource_group.us.name

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_application_security_group" "sa" {
  name                = "asg-sa${local.resource_template}001"
  location            = azurerm_resource_group.us.location
  resource_group_name = azurerm_resource_group.us.name

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_network_security_group" "nsg" {
  name                = local.vnet_snet_nsg_name
  location            = azurerm_resource_group.us.location
  resource_group_name = azurerm_resource_group.us.name

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_network_security_rule" "rules" {
  for_each = var.nsg_map

  name                                       = each.value.name
  network_security_group_name                = azurerm_network_security_group.nsg.name
  resource_group_name                        = azurerm_resource_group.us.name
  priority                                   = each.value.priority
  direction                                  = each.value.direction
  access                                     = each.value.access
  protocol                                   = each.value.protocol
  source_port_range                          = "*"
  destination_port_range                     = each.value.destination_port_range
  source_address_prefixes                    = each.value.source_address_prefixes
  destination_application_security_group_ids = [azurerm_application_security_group.sql.id]

  depends_on = [azurerm_network_security_group.nsg]
}

resource "azurerm_network_security_rule" "storage" {
  name                                       = "StorageAllow"
  network_security_group_name                = azurerm_network_security_group.nsg.name
  resource_group_name                        = azurerm_resource_group.us.name
  priority                                   = 400
  direction                                  = "Inbound"
  access                                     = "Allow"
  protocol                                   = "*"
  source_port_range                          = "*"
  destination_port_range                     = "443"
  source_address_prefixes                    = ["10.0.0.0/8", "192.168.0.0/16", "172.16.0.0/12"]
  destination_application_security_group_ids = [azurerm_application_security_group.sa.id]
}

resource "azurerm_subnet_network_security_group_association" "us" {
  subnet_id                 = azurerm_subnet.us.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# ASG Association

resource "azurerm_private_endpoint_application_security_group_association" "sql" {
  private_endpoint_id           = azurerm_private_endpoint.sql.id
  application_security_group_id = azurerm_application_security_group.sql.id
}

resource "azurerm_private_endpoint_application_security_group_association" "sa" {
  private_endpoint_id           = azurerm_private_endpoint.sa.id
  application_security_group_id = azurerm_application_security_group.sa.id
}


#DNS Links

resource "azurerm_private_dns_zone_virtual_network_link" "links" {
  provider = azurerm.platform
  for_each = var.dns_zones

  name                  = "pl-${each.value.short_name}-${azurerm_virtual_network.us.name}"
  resource_group_name   = "rg-privatedns-p-us-001"
  private_dns_zone_name = each.value.name
  virtual_network_id    = azurerm_virtual_network.us.id

  lifecycle {
    ignore_changes = [tags]
  }
}

#Peering for ExpressRoute

resource "azurerm_virtual_hub_connection" "us" {
  provider                  = azurerm.platform
  name                      = "conn-${local.vnet_name}"
  virtual_hub_id            = data.azurerm_virtual_hub.us.id
  remote_virtual_network_id = azurerm_virtual_network.us.id
}
