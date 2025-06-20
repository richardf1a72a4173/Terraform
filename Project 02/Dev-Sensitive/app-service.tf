resource "azurerm_service_plan" "plan" {
  name                   = local.plan_name
  location               = azurerm_resource_group.rg.location
  resource_group_name    = azurerm_resource_group.rg.name
  sku_name               = local.env == "p" ? var.plan_sku_name : "B3"
  os_type                = var.os_plan_type
  zone_balancing_enabled = local.env == "p" ? true : false

  lifecycle {
    ignore_changes = [tags, sku_name]
  }
}

resource "azurerm_application_insights" "app" {
  name                = local.appin_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type    = "web"

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_linux_web_app" "app" {
  name                = local.app_name
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
    APP_DOMAIN                                 = data.azurerm_dns_zone.devdns.name
    APP_PTP_DOMAIN                             = local.app_hostname
    APP_PROFICIENCY_PULSE_DOMAIN               = local.app_hostname_2
  }

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [tags, site_config, app_settings, sticky_settings]
  }
}

# Dont think this is needed

# resource "azurerm_app_service_virtual_network_swift_connection" "vnet" {
#   app_service_id = azurerm_linux_web_app.app.id
#   subnet_id      = azurerm_subnet.app.id
# }

# Manual creation of Service Connections required for now

# resource "azurerm_app_service_connection" "files" {
#   app_service_id     = azurerm_linux_web_app.app.id
#   client_type        = "php"
#   name               = "filesasc001"
#   target_resource_id = azurerm_storage_account.storage.id
#   vnet_solution      = "privateLink"
#   authentication {
#     certificate     = null
#     client_id       = null
#     name            = "CONNECTION_STRING"
#     principal_id    = null
#     secret          = azurerm_storage_account.storage.primary_connection_string
#     subscription_id = null
#     type            = "secret"
#   }
# }

# resource "azurerm_app_service_connection" "mysql" {
#   app_service_id     = azurerm_linux_web_app.app.id
#   client_type        = "php"
#   name               = "mysqlasc001"
#   target_resource_id = azurerm_mysql_flexible_database.database.id
#   vnet_solution      = null
#   authentication {
#     certificate     = null
#     client_id       = null
#     name            = azurerm_mysql_flexible_server.mysql.administrator_login
#     principal_id    = null
#     secret          = azurerm_mysql_flexible_server.mysql.administrator_password
#     subscription_id = null
#     type            = "secret"
#   }
# }
