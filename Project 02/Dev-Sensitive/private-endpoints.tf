resource "azurerm_private_endpoint" "kv" {
  name                = local.kv_pe_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  subnet_id           = azurerm_subnet.pe.id

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

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_private_endpoint" "sa" {
  name                = local.sa_privlink_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  subnet_id           = azurerm_subnet.pe.id

  private_service_connection {
    name                           = local.sa_psc_name
    private_connection_resource_id = azurerm_storage_account.storage.id
    is_manual_connection           = false
    subresource_names = [
      "file"
    ]
  }

  private_dns_zone_group {
    name                 = "privatelink.file.core.windows.net"
    private_dns_zone_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-privatedns-p-us-001/providers/Microsoft.Network/privateDnsZones/privatelink.file.core.windows.net"]
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_private_endpoint" "app" {
  name                = local.appservice_pe_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.pe.id


  private_service_connection {
    name                           = local.appservice_psc_name
    private_connection_resource_id = azurerm_linux_web_app.app.id
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

resource "azurerm_private_endpoint_application_security_group_association" "app" {
  private_endpoint_id           = azurerm_private_endpoint.app.id
  application_security_group_id = azurerm_application_security_group.asg[2].id
}

resource "azurerm_private_endpoint_application_security_group_association" "kv" {
  private_endpoint_id           = azurerm_private_endpoint.kv.id
  application_security_group_id = azurerm_application_security_group.asg[2].id
}

resource "azurerm_private_endpoint_application_security_group_association" "sa" {
  private_endpoint_id           = azurerm_private_endpoint.sa.id
  application_security_group_id = azurerm_application_security_group.asg[2].id
}
