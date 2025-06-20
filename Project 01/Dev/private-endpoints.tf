resource "azurerm_private_endpoint" "kv" {
  name                = local.kv_pe_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  subnet_id           = local.subnets_by_name["snet-${local.suffix}-001"].id

  private_service_connection {
    name                           = local.kv_psc_name
    private_connection_resource_id = azurerm_key_vault.kv.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "privatelink.vaultcore.azure.net"
    private_dns_zone_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-privatedns-p-us-001/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net"]
  }
}

#resource "azurerm_private_endpoint_application_security_group_association" "kv" {
#  private_endpoint_id           = azurerm_private_endpoint.kv.id
#  application_security_group_id = azurerm_application_security_group.app.id
#}

resource "azurerm_private_endpoint" "sql" {
  name                = local.sql_priv_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  subnet_id           = local.subnets_by_name["snet-${local.suffix}-002"].id

  private_service_connection {
    name                           = local.sql_priv_ser_name
    is_manual_connection           = false
    private_connection_resource_id = azurerm_mssql_server.sql.id
    subresource_names              = ["sqlServer"]
  }

  private_dns_zone_group {
    name                 = "privatelink.database.windows.net"
    private_dns_zone_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-privatedns-p-us-001/providers/Microsoft.Network/privateDnsZones/privatelink.database.windows.net"]
  }
}

resource "azurerm_private_endpoint" "fa" {
  count               = 2
  name                = "${local.fa_pe_name}-00${count.index}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  subnet_id           = local.subnets_by_name["snet-${local.suffix}-001"].id

  private_service_connection {
    name                           = local.fa_psc_name
    private_connection_resource_id = azurerm_windows_function_app.fa[count.index].id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "privatelink.azurewebsites.net"
    private_dns_zone_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-privatedns-p-us-001/providers/Microsoft.Network/privateDnsZones/privatelink.azurewebsites.net"]
  }
}

resource "azurerm_private_endpoint" "sa" {
  count               = 3
  name                = "${local.sa_privlink_name}-00${count.index}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  subnet_id           = local.subnets_by_name["snet-${local.suffix}-001"].id

  private_service_connection {
    name                           = local.sa_psc_name
    private_connection_resource_id = azurerm_storage_account.sa[count.index].id
    is_manual_connection           = false
    subresource_names = [
      "blob"
    ]
  }

  private_dns_zone_group {
    name                 = "privatelink.blob.core.windows.net"
    private_dns_zone_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-privatedns-p-us-001/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"]
  }
}

resource "azurerm_private_endpoint" "app" {
  count               = 2
  name                = element(local.appservice_pe_name, count.index)
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = local.subnets_by_name["snet-${local.suffix}-001"].id


  private_service_connection {
    name                           = element(local.appservice_psc_name, count.index)
    private_connection_resource_id = azurerm_windows_web_app.app[count.index].id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "privatelink.azurewebsites.net"
    private_dns_zone_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-privatedns-p-us-001/providers/Microsoft.Network/privateDnsZones/privatelink.azurewebsites.net"]
  }
}
