# App Service Plan

resource "azurerm_service_plan" "us" {
  app_service_environment_id = null
  location                   = azurerm_resource_group.us.location
  name                       = module.naming.app_service_plan.name
  resource_group_name        = azurerm_resource_group.us.name
  os_type                    = "Windows"
  sku_name                   = "P1v3"
  zone_balancing_enabled     = true
  worker_count               = 3

  lifecycle {
    ignore_changes = [tags]
  }
}

# App Service

resource "azurerm_windows_web_app" "us" {
  name                = module.naming.app_service.name
  resource_group_name = azurerm_resource_group.us.name
  location            = azurerm_service_plan.us.location
  service_plan_id     = azurerm_service_plan.us.id
  https_only          = true

  site_config {
    use_32_bit_worker                 = false
    health_check_path                 = "/"
    health_check_eviction_time_in_min = 5
  }

  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY"        = azurerm_application_insights.app.instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = azurerm_application_insights.app.connection_string
  }

  virtual_network_subnet_id = azurerm_subnet.us[0].id

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [site_config, app_settings, auth_settings_v2, sticky_settings, tags]
    # prevent_destroy = true
  }
}

resource "azurerm_windows_web_app_slot" "slot1" {
  name           = "${module.naming.app_service.name}-slot-001"
  app_service_id = azurerm_windows_web_app.us.id
  https_only     = true

  site_config {
    application_stack {
      dotnet_core_version = "v4.0"
      dotnet_version      = "v8.0"
    }

    ip_restriction {
      ip_address = "${var.dev_ip}/32"
      action     = "Allow"
      priority   = 200
    }

    ip_restriction_default_action = "Deny"
  }

  virtual_network_subnet_id = azurerm_subnet.us[0].id

  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY"        = azurerm_application_insights.app.instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = azurerm_application_insights.app.connection_string
  }

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [tags, site_config, app_settings, connection_string, identity]
    # prevent_destroy = true
  }
}

resource "azurerm_windows_web_app_slot" "slot2" {
  name           = "${module.naming.app_service.name}-slot-002"
  app_service_id = azurerm_windows_web_app.us.id
  https_only     = true

  site_config {
    application_stack {
      dotnet_core_version = "v4.0"
      dotnet_version      = "v8.0"
    }

    ip_restriction {
      ip_address = "${var.dev_ip}/32"
      action     = "Allow"
      priority   = 200
    }

    ip_restriction_default_action = "Deny"
  }

  identity {
    type = "SystemAssigned"
  }

  virtual_network_subnet_id = azurerm_subnet.us[0].id

  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY"        = azurerm_application_insights.app.instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = azurerm_application_insights.app.connection_string
  }

  lifecycle {
    ignore_changes = [tags, site_config, app_settings, connection_string, identity]
    # prevent_destroy = true
  }
}
