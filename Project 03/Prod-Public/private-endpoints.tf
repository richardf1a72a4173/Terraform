resource "azurerm_private_endpoint" "sql" {
  name                = "${module.naming.private_endpoint.name}-sql"
  resource_group_name = azurerm_resource_group.us.name
  location            = azurerm_resource_group.us.location
  subnet_id           = azurerm_subnet.us[2].id

  private_service_connection {
    name                           = "${module.naming.private_service_connection.name}-sql"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_mssql_server.us.id
    subresource_names              = ["sqlServer"]
  }

  private_dns_zone_group {
    name                 = "privatelink.database.windows.net"
    private_dns_zone_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-privatedns-p-us-001/providers/Microsoft.Network/privateDnsZones/privatelink.database.windows.net"]
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_private_endpoint" "sa" {
  name                = "${module.naming.private_endpoint.name}-sa"
  resource_group_name = azurerm_resource_group.us.name
  location            = azurerm_resource_group.us.location
  subnet_id           = azurerm_subnet.us[2].id

  private_service_connection {
    name                           = "${module.naming.private_service_connection.name}-sa"
    private_connection_resource_id = azurerm_storage_account.us.id
    is_manual_connection           = false
    subresource_names = [
      "blob"
    ]
  }

  private_dns_zone_group {
    name                 = "privatelink.blob.core.windows.net"
    private_dns_zone_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-privatedns-p-us-001/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"]
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_private_endpoint" "app" {
  name                = "${module.naming.private_endpoint.name}-app"
  location            = azurerm_resource_group.us.location
  resource_group_name = azurerm_resource_group.us.name
  subnet_id           = azurerm_subnet.us[2].id


  private_service_connection {
    name                           = "${module.naming.private_service_connection.name}-app"
    private_connection_resource_id = azurerm_windows_web_app.us.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "privatelink.azurewebsites.net"
    private_dns_zone_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-privatedns-p-us-001/providers/Microsoft.Network/privateDnsZones/privatelink.azurewebsites.net"]
  }

  lifecycle {
    ignore_changes = [tags]
  }
}
