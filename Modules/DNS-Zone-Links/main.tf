resource "azurerm_private_dns_zone_virtual_network_link" "links" {
  for_each = var.dns_zones

  name                  = "pl-${each.value.short_name}-${var.vnet_name}"
  resource_group_name   = var.private_dns_zone_rg_name
  private_dns_zone_name = each.value.name
  virtual_network_id    = var.virtual_network_id

  lifecycle {
    ignore_changes = [tags]
  }
}
