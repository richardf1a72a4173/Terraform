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

resource "azurerm_dns_a_record" "h1" {
  provider            = azurerm.platform
  name                = local.hostname
  resource_group_name = data.azurerm_dns_zone.devdns.resource_group_name
  zone_name           = data.azurerm_dns_zone.devdns.name
  ttl                 = 300
  target_resource_id  = azurerm_public_ip.pip.id
}

resource "azurerm_dns_a_record" "h2" {
  provider            = azurerm.platform
  name                = local.hostname2
  resource_group_name = data.azurerm_dns_zone.devdns.resource_group_name
  zone_name           = data.azurerm_dns_zone.devdns.name
  ttl                 = 300
  target_resource_id  = azurerm_public_ip.pip.id
}
