resource "azurerm_virtual_network" "vnet" {
  resource_group_name = var.rg_name
  location            = var.location
  name                = "vnet${var.resource_template}001"
  address_space       = [var.vnet_address]

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_subnet" "subnet" {
  resource_group_name             = var.rg_name
  name                            = "snet${var.resource_template}001"
  virtual_network_name            = azurerm_virtual_network.vnet.name
  address_prefixes                = [var.snet_address]
  default_outbound_access_enabled = var.nat_gateway ? false : true

  lifecycle {
    ignore_changes = [delegation]
  }
}

resource "azurerm_nat_gateway" "nat" {
  count                   = var.nat_gateway ? 1 : 0
  name                    = "nat${var.resource_template}001"
  location                = var.location
  resource_group_name     = var.rg_name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  zones                   = azurerm_public_ip.nat[0].zones

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_public_ip" "nat" {
  count               = var.nat_gateway ? 1 : 0
  name                = "pip${var.resource_template}001"
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_nat_gateway_public_ip_association" "nat" {
  count                = var.nat_gateway ? 1 : 0
  nat_gateway_id       = azurerm_nat_gateway.nat[0].id
  public_ip_address_id = azurerm_public_ip.nat[0].id
}
