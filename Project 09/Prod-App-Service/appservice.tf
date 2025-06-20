resource "azurerm_service_plan" "plan" {
  name                   = "asp${local.resource_template}001"
  location               = azurerm_resource_group.rg.location
  resource_group_name    = azurerm_resource_group.rg.name
  sku_name               = "P1v3"
  os_type                = "Linux"
  zone_balancing_enabled = local.env == "p" ? true : false

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_application_insights" "app" {
  name                = "ai${local.resource_template}001"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "web"

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_linux_web_app" "app" {
  name                = "app${local.resource_template}001"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {
    application_stack {
      php_version = 8.3
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
    ignore_changes = [tags, site_config, app_settings, sticky_settings]
  }
}

resource "azurerm_linux_web_app_slot" "prod" {
  name           = "app-slot-prod${local.resource_template}001"
  app_service_id = azurerm_linux_web_app.app.id

  site_config {

  }
}

resource "azurerm_linux_web_app_slot" "staging" {
  name           = "app-slot-staging${local.resource_template}001"
  app_service_id = azurerm_linux_web_app.app.id

  site_config {

  }
}
