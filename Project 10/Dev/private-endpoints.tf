resource "azurerm_private_endpoint" "sql" {
  name                = local.sql_priv_name
  resource_group_name = azurerm_resource_group.us.name
  location            = azurerm_resource_group.us.location
  subnet_id           = azurerm_subnet.us.id

  private_service_connection {
    name                           = local.sql_priv_ser_name
    is_manual_connection           = false
    private_connection_resource_id = azurerm_mssql_server.us.id
    subresource_names              = ["sqlServer"]
  }

  private_dns_zone_group {
    name                 = "privatelink.database.windows.net"
    private_dns_zone_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-privatedns-p-us-001/providers/Microsoft.Network/privateDnsZones/privatelink.database.windows.net"]
  }
}
