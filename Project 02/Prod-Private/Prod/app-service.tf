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

resource "azurerm_monitor_autoscale_setting" "autoscale" {
  name                = "autoscale-app${local.resource_template}001"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  target_resource_id  = azurerm_service_plan.plan.id

  profile {
    name = "AutoScaleProfile"

    capacity {
      default = 1
      minimum = 1
      maximum = 4
    }
  }
}

resource "azurerm_linux_web_app" "app" {
  name                          = "app${local.resource_template}001"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  service_plan_id               = azurerm_service_plan.plan.id
  public_network_access_enabled = true

  https_only = true

  site_config {
    application_stack {
      php_version = 8.3
    }
    app_command_line                  = "bash /home/postDeploy.sh && bash /home/startup.sh"
    http2_enabled                     = true
    ftps_state                        = "Disabled"
    health_check_path                 = "/en/home"
    health_check_eviction_time_in_min = 10
    # auto_heal_enabled = true
    auto_heal_setting {
      action {
        action_type = "Recycle"
      }
    }
    ip_restriction_default_action = "Deny"
    ip_restriction {
      action     = "Allow"
      ip_address = "${data.http.myip.response_body}/32"
      priority   = 200
      name       = "Client Access"
    }
    ip_restriction {
      action     = "Allow"
      ip_address = "${var.dev_ip}/32"
      priority   = 210
      name       = "Dev Access"
    }
  }

  virtual_network_subnet_id = azurerm_subnet.app.id

  app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY             = azurerm_application_insights.app.instrumentation_key
    APPLICATIONINSIGHTS_CONNECTION_STRING      = azurerm_application_insights.app.connection_string
    ApplicationInsightsAgent_EXTENSION_VERSION = "~3"
    WEBSITES_ENABLE_APP_SERVICE_STORAGE        = true
    APP_DOMAIN                                 = var.http_hostname
    APP_PTP_DOMAIN                             = var.http_hostname
    APP_PROFICIENCY_PULSE_DOMAIN               = var.http_hostname_2
  }

  sticky_settings {
    app_setting_names = ["APP_DOMAIN", "APP_project02_DOMAIN", "APP_project02_DOMAIN"]
  }

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [tags, storage_account, app_settings, sticky_settings, site_config, logs]
  }
}

resource "azurerm_linux_web_app_slot" "staging" {
  name                          = "app-slot-staging${local.resource_template}001"
  app_service_id                = azurerm_linux_web_app.app.id
  public_network_access_enabled = true

  https_only = true

  site_config {
    application_stack {
      php_version = 8.3
    }

    http2_enabled                     = true
    ftps_state                        = "Disabled"
    health_check_path                 = "/en/home"
    health_check_eviction_time_in_min = 10

    ip_restriction_default_action = "Deny"
    ip_restriction {
      action     = "Allow"
      ip_address = "${azurerm_public_ip.pip.ip_address}/32"
      priority   = 100
      name       = "App Gateway"
    }
    ip_restriction {
      action     = "Allow"
      ip_address = "${data.http.myip.response_body}/32"
      priority   = 200
      name       = "Client Access"
    }
    ip_restriction {
      action     = "Allow"
      ip_address = "${var.dev_ip}/32"
      priority   = 210
      name       = "Dev Access"
    }
  }

  virtual_network_subnet_id = azurerm_subnet.app.id

  app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY             = azurerm_application_insights.app.instrumentation_key
    APPLICATIONINSIGHTS_CONNECTION_STRING      = azurerm_application_insights.app.connection_string
    ApplicationInsightsAgent_EXTENSION_VERSION = "~3"
    WEBSITES_ENABLE_APP_SERVICE_STORAGE        = true
    APP_DOMAIN                                 = var.http_hostname
    APP_PTP_DOMAIN                             = "stg.${var.http_hostname}"
    APP_PROFICIENCY_PULSE_DOMAIN               = "stg-${var.http_hostname_2}"
  }

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [tags, storage_account, app_settings, site_config]
  }
}
