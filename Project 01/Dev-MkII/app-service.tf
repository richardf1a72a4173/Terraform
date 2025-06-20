resource "azurerm_windows_web_app" "app" {
  count                         = 2
  name                          = "app${local.resource_template}00${count.index + 1}"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  service_plan_id               = azurerm_service_plan.asp[1].id
  public_network_access_enabled = false
  virtual_network_subnet_id     = azurerm_subnet.app.id
  https_only                    = true

  site_config {
    use_32_bit_worker             = false
    ip_restriction_default_action = "Deny"
    application_stack {
      dotnet_core_version = "v4.0"
      dotnet_version      = "v8.0"
    }
  }

  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY"        = azurerm_application_insights.appins.instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = azurerm_application_insights.appins.connection_string
  }

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [tags, site_config]
  }
}

resource "azurerm_app_configuration" "appconf" {
  name                = "appconf${local.resource_template}001"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  sku                   = "standard"
  public_network_access = "Disabled"

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [tags]
  }
}
