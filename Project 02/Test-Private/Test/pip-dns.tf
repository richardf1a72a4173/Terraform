resource "azurerm_public_ip" "pip" {
  name                = module.naming.public_ip.name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  # zones                = ["1", "2", "3"]
  sku = "Standard"
  # ddos_protection_mode = "Enabled"

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_dns_a_record" "test" {
  count               = 2
  provider            = azurerm.platform
  name                = trimprefix("${local.resource_template}00${count.index + 1}", "-")
  zone_name           = data.azurerm_dns_zone.devdns.name
  resource_group_name = data.azurerm_dns_zone.devdns.resource_group_name
  target_resource_id  = azurerm_public_ip.pip.id
  ttl                 = 300
}
