resource "azurerm_service_plan" "plan" {
  name                   = "asp${local.resource_template}001"
  location               = azurerm_resource_group.rg.location
  resource_group_name    = azurerm_resource_group.rg.name
  sku_name               = local.env == "p" ? var.plan_sku_name : "P1v3"
  os_type                = var.os_plan_type
  zone_balancing_enabled = local.env == "p" ? true : false

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_windows_web_app" "app" {
  name                          = "app${local.resource_template}001"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  service_plan_id               = azurerm_service_plan.plan.id
  public_network_access_enabled = false

  site_config {
    application_stack {

    }
  }

  virtual_network_subnet_id = azurerm_subnet.app.id

  app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY             = azurerm_application_insights.app.instrumentation_key
    APPLICATIONINSIGHTS_CONNECTION_STRING      = azurerm_application_insights.app.connection_string
    ApplicationInsightsAgent_EXTENSION_VERSION = "~3"
    WEBSITES_ENABLE_APP_SERVICE_STORAGE        = true
  }

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [tags, site_config, app_settings, sticky_settings, storage_account, public_network_access_enabled]
  }
}
