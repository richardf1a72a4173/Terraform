resource "azurerm_public_ip" "pip" {
  name                = "pip${local.resource_template}001"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  zones               = ["1", "2", "3"]
  sku                 = "Standard"

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_management_lock" "pip" {
  name       = "PIP"
  scope      = azurerm_public_ip.pip.id
  lock_level = "CanNotDelete"
  notes      = "Delete Resource Lock"
}

resource "azurerm_dns_a_record" "h1" {
  name                = "@"
  resource_group_name = azurerm_resource_group.rg.name
  zone_name           = azurerm_dns_zone.ptpscheme.name
  ttl                 = 300
  target_resource_id  = azurerm_public_ip.pip.id
}
