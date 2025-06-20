resource "azurerm_dns_zone" "dns" {
  name                = local.dns_zone_name
  resource_group_name = azurerm_resource_group.rg.name

  lifecycle {
    ignore_changes = [tags]
  }
}
