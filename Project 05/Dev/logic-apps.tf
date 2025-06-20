resource "azurerm_service_plan" "asp" {
  name                = "asp${local.resource_template}001"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Windows"
  sku_name            = "WS1"

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_logic_app_standard" "la" {
  count = 2

  name                       = "la${local.resource_template}00${count.index + 1}"
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = azurerm_resource_group.rg.location
  app_service_plan_id        = azurerm_service_plan.asp.id
  storage_account_name       = azurerm_storage_account.storage[count.index].name
  storage_account_access_key = azurerm_storage_account.storage[count.index].primary_access_key
  virtual_network_subnet_id  = azurerm_subnet.snets[2].id
  version                    = "~4"
  https_only                 = true

  site_config {
    dotnet_framework_version  = "v8.0"
    use_32_bit_worker_process = false
  }

  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY"        = azurerm_application_insights.appins.instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = azurerm_application_insights.appins.connection_string
  }

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [tags, site_config, app_settings]
  }
}
