resource "azurerm_private_endpoint" "sql" {
  name                = local.sql_priv_name
  resource_group_name = azurerm_resource_group.us.name
  location            = azurerm_resource_group.us.location
  subnet_id           = local.subnets_by_name["snet${local.resource_template}003"].id

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

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_private_endpoint" "sa" {
  name                = local.sa_privlink_name
  resource_group_name = azurerm_resource_group.us.name
  location            = azurerm_resource_group.us.location
  subnet_id           = local.subnets_by_name["snet${local.resource_template}002"].id

  private_service_connection {
    name                           = local.sa_psc_name
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
  name                = local.appservice_pe_name
  location            = azurerm_resource_group.us.location
  resource_group_name = azurerm_resource_group.us.name
  subnet_id           = local.subnets_by_name["snet${local.resource_template}002"].id


  private_service_connection {
    name                           = local.appservice_psc_name
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

resource "azurerm_private_endpoint" "ds1" {
  name                = local.slots_pe_name[0]
  location            = azurerm_resource_group.us.location
  resource_group_name = azurerm_resource_group.us.name
  subnet_id           = local.subnets_by_name["snet${local.resource_template}002"].id

  private_service_connection {
    name                           = local.ds_psc_name[0]
    private_connection_resource_id = azurerm_windows_web_app.us.id
    subresource_names              = ["sites-${local.appserviceslot1_name}"]
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

resource "azurerm_private_endpoint" "ds2" {
  name                = local.slots_pe_name[1]
  location            = azurerm_resource_group.us.location
  resource_group_name = azurerm_resource_group.us.name
  subnet_id           = local.subnets_by_name["snet${local.resource_template}002"].id

  private_service_connection {
    name                           = local.ds_psc_name[1]
    private_connection_resource_id = azurerm_windows_web_app.us.id
    subresource_names              = ["sites-${local.appserviceslot2_name}"]
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
