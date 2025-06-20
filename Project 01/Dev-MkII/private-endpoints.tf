resource "azurerm_private_endpoint" "kv" {
  name                = "pe-kv${local.resource_template}001"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  subnet_id           = azurerm_subnet.pe.id

  private_service_connection {
    name                           = "psc-kv${local.resource_template}001"
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
  count               = length(azurerm_storage_account.storage)
  name                = "pe-sa${local.resource_template}00${count.index + 1}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  subnet_id           = azurerm_subnet.pe.id

  private_service_connection {
    name                           = "psc-sa${local.resource_template}00${count.index + 1}"
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

resource "azurerm_private_endpoint" "app" {
  count               = length(azurerm_windows_web_app.app)
  name                = "pe-app${local.resource_template}00${count.index + 1}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.pe.id


  private_service_connection {
    name                           = "psc-app${local.resource_template}00${count.index + 1}"
    private_connection_resource_id = azurerm_windows_web_app.app[count.index].id
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

resource "azurerm_private_endpoint" "fapp" {
  count               = length(azurerm_windows_function_app.fa)
  name                = "pe-fapp${local.resource_template}00${count.index + 1}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.pe.id


  private_service_connection {
    name                           = "psc-fapp${local.resource_template}00${count.index + 1}"
    private_connection_resource_id = azurerm_windows_function_app.fa[count.index].id
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

resource "azurerm_private_endpoint" "sql" {
  name                = "pe-sql${local.resource_template}001"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.pe.id

  private_service_connection {
    name                           = "psc-sql${local.resource_template}001"
    private_connection_resource_id = azurerm_mssql_server.sql.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "privatelink.database.windows.net"
    private_dns_zone_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-privatedns-p-us-001/providers/Microsoft.Network/privateDnsZones/privatelink.database.windows.net"]
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_private_endpoint" "appconf" {
  name                = "pe-appconf${local.resource_template}001"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.pe.id

  private_service_connection {
    name                           = "psc-appconf${local.resource_template}001"
    private_connection_resource_id = azurerm_app_configuration.appconf.id
    subresource_names              = ["configurationStores"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "privatelink.azconfig.io"
    private_dns_zone_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-privatedns-p-us-001/providers/Microsoft.Network/privateDnsZones/privatelink.azconfig.io"]
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_private_endpoint_application_security_group_association" "app" {
  count                         = length(azurerm_private_endpoint.app)
  private_endpoint_id           = azurerm_private_endpoint.app[count.index].id
  application_security_group_id = azurerm_application_security_group.asg[2].id
}

resource "azurerm_private_endpoint_application_security_group_association" "fapp" {
  count                         = length(azurerm_private_endpoint.fapp)
  private_endpoint_id           = azurerm_private_endpoint.fapp[count.index].id
  application_security_group_id = azurerm_application_security_group.asg[2].id
}

resource "azurerm_private_endpoint_application_security_group_association" "kv" {
  private_endpoint_id           = azurerm_private_endpoint.kv.id
  application_security_group_id = azurerm_application_security_group.asg[2].id
}

resource "azurerm_private_endpoint_application_security_group_association" "sa" {
  count                         = length(azurerm_private_endpoint.sa)
  private_endpoint_id           = azurerm_private_endpoint.sa[count.index].id
  application_security_group_id = azurerm_application_security_group.asg[2].id
}

resource "azurerm_private_endpoint_application_security_group_association" "sql" {
  private_endpoint_id           = azurerm_private_endpoint.sql.id
  application_security_group_id = azurerm_application_security_group.asg[2].id
}

resource "azurerm_private_endpoint_application_security_group_association" "appconf" {
  private_endpoint_id           = azurerm_private_endpoint.appconf.id
  application_security_group_id = azurerm_application_security_group.asg[2].id
}
