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

resource "azurerm_dns_a_record" "dns-pip" {
  count               = 2
  provider            = azurerm.platform
  name                = "${trimprefix(local.resource_template, "-")}00${count.index + 1}"
  resource_group_name = data.azurerm_dns_zone.devdns.resource_group_name
  zone_name           = data.azurerm_dns_zone.devdns.name
  ttl                 = 300
  target_resource_id  = azurerm_public_ip.pip.id
}
