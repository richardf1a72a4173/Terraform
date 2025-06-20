resource "azurerm_dns_zone" "prod" {
  name                = var.prod_domain
  resource_group_name = azurerm_resource_group.us.name

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_dns_a_record" "prod" {
  name                = trim(var.prod_domain, ".aircomlabs.com")
  resource_group_name = azurerm_resource_group.us.name
  zone_name           = azurerm_dns_zone.prod.name
  ttl                 = 300
  target_resource_id  = azurerm_cdn_frontdoor_endpoint.endpoint.id

  depends_on = [azurerm_cdn_frontdoor_endpoint.endpoint]
}

resource "azurerm_dns_txt_record" "validation" {
  name                = "_dnsauth.${trim(var.prod_domain, ".aircomlabs.com")}"
  resource_group_name = azurerm_resource_group.us.name
  zone_name           = azurerm_dns_zone.prod.name
  record {
    value = azurerm_cdn_frontdoor_custom_domain.prod.validation_token
  }
  ttl = 300
}
