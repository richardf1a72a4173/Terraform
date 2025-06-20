# App Service Plan

resource "azurerm_service_plan" "us" {
  app_service_environment_id = null
  location                   = azurerm_resource_group.us.location
  name                       = local.app_serplan_name
  resource_group_name        = azurerm_resource_group.us.name
  os_type                    = "Windows"
  sku_name                   = "S1"

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_application_insights" "appins" {
  name                = local.appins_name
  resource_group_name = azurerm_resource_group.us.name
  location            = azurerm_resource_group.us.location
  application_type    = "web"

  lifecycle {
    ignore_changes = [tags]
  }
}

# App Service

resource "azurerm_windows_web_app" "us" {
  name                = local.app_name
  resource_group_name = azurerm_resource_group.us.name
  location            = azurerm_service_plan.us.location
  service_plan_id     = azurerm_service_plan.us.id

  site_config {
    use_32_bit_worker = false
  }

  virtual_network_subnet_id = local.subnets_by_name["snet${local.resource_template}001"].id

  lifecycle {
    ignore_changes = [site_config, app_settings, auth_settings_v2, sticky_settings, tags]
    # prevent_destroy = true
  }
}

# resource "azurerm_app_service_virtual_network_swift_connection" "vnet" {
#   app_service_id = azurerm_windows_web_app.us.id
#   subnet_id      = local.subnets_by_name["snet${local.resource_template}001"].id
# }

resource "azurerm_windows_web_app_slot" "slot1" {
  name           = local.appserviceslot1_name
  app_service_id = azurerm_windows_web_app.us.id

  site_config {
    application_stack {
      dotnet_core_version = "v4.0"
      dotnet_version      = "v8.0"
    }
  }


  virtual_network_subnet_id = local.subnets_by_name["snet${local.resource_template}001"].id

  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY"        = azurerm_application_insights.appins.instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = azurerm_application_insights.appins.connection_string
  }

  lifecycle {
    ignore_changes = [tags, site_config, app_settings, connection_string, identity]
    # prevent_destroy = true
  }
}

resource "azurerm_windows_web_app_slot" "slot2" {
  name           = local.appserviceslot2_name
  app_service_id = azurerm_windows_web_app.us.id

  site_config {
    application_stack {
      dotnet_core_version = "v4.0"
      dotnet_version      = "v8.0"
    }
  }


  virtual_network_subnet_id = local.subnets_by_name["snet${local.resource_template}001"].id

  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY"        = azurerm_application_insights.appins.instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = azurerm_application_insights.appins.connection_string
  }

  lifecycle {
    ignore_changes = [tags, site_config, app_settings, connection_string, identity]
    # prevent_destroy = true
  }
}
