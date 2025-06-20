module "vnet" {
  source            = "../../Modules/VNET"
  location          = azurerm_resource_group.rg.location
  rg_name           = azurerm_resource_group.rg.name
  nat_gateway       = true
  resource_template = local.resource_template
  vnet_address      = "172.31.201.0/24"
  snet_address      = "172.31.201.0/24"
}

resource "azurerm_network_security_group" "nsg" {
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  name                = "nsg${local.resource_template}001"

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
  destination_address_prefixes = ["172.31.201.0/24"]

  depends_on = [azurerm_network_security_group.nsg]
}

resource "azurerm_subnet_network_security_group_association" "nsg" {
  subnet_id                 = module.vnet.snet_id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
