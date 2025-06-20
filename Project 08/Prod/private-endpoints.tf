resource "azurerm_private_endpoint" "kv" {
  name                = "${module.naming.private_endpoint.name}-kv"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  subnet_id           = azurerm_subnet.snets[1].id

  private_service_connection {
    name                           = "${module.naming.private_service_connection.name}-kv"
    private_connection_resource_id = azurerm_key_vault.kv.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "privatelink.vaultcore.azure.net"
    private_dns_zone_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-privatedns-p-us-001/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net"]
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_private_endpoint" "sa" {
  count = length(azurerm_storage_account.storage)

  name                = "${module.naming.private_endpoint.name}-sa-00${count.index + 1}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  subnet_id           = azurerm_subnet.snets[1].id

  private_service_connection {
    name                           = "${module.naming.private_service_connection.name}-sa00${count.index + 1}"
    private_connection_resource_id = azurerm_storage_account.storage[count.index].id
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

resource "azurerm_private_endpoint" "la" {
  count = length(azurerm_logic_app_standard.la)

  name                = "${module.naming.private_endpoint.name}-la-00${count.index + 1}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  subnet_id           = azurerm_subnet.snets[1].id

  private_service_connection {
    name                           = "${module.naming.private_endpoint.name}-la-00${count.index + 1}"
    private_connection_resource_id = azurerm_logic_app_standard.la[count.index].id
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

resource "azurerm_private_endpoint" "sb" {
  name                = "${module.naming.private_endpoint.name}-sb"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  subnet_id           = azurerm_subnet.snets[1].id

  private_service_connection {
    name                           = "${module.naming.private_service_connection.name}-sb"
    private_connection_resource_id = azurerm_servicebus_namespace.namespace.id
    is_manual_connection           = false
    subresource_names = [
      "namespace"
    ]
  }

  private_dns_zone_group {
    name                 = "privatelink.servicebus.windows.net"
    private_dns_zone_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-privatedns-p-us-001/providers/Microsoft.Network/privateDnsZones/privatelink.servicebus.windows.net"]
  }

  lifecycle {
    ignore_changes = [tags]
  }
}
