resource "azurerm_monitor_workspace" "monitor" {
  name                = "mon${local.resource_template}001"
  resource_group_name = azurerm_resource_group.us.name
  location            = azurerm_resource_group.us.location

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_log_analytics_workspace" "workspace" {
  name                = module.naming.log_analytics_workspace.name
  resource_group_name = azurerm_resource_group.us.name
  location            = azurerm_resource_group.us.location

  sku               = "PerGB2018"
  retention_in_days = 30

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_application_insights" "app" {
  name                = module.naming.application_insights.name
  location            = azurerm_resource_group.us.location
  resource_group_name = azurerm_resource_group.us.name
  application_type    = "web"

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting" {
  count                      = length(local.targets_resource_id)
  name                       = split("/", azurerm_log_analytics_workspace.workspace.id)[length(split("/", azurerm_log_analytics_workspace.workspace.id)) - 1]
  target_resource_id         = data.azurerm_monitor_diagnostic_categories.categories[count.index].id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.workspace.id

  dynamic "metric" {
    for_each = data.azurerm_monitor_diagnostic_categories.categories[count.index].metrics
    content {
      category = metric.value
      enabled  = true
    }
  }

  dynamic "enabled_log" {
    for_each = data.azurerm_monitor_diagnostic_categories.categories[count.index].log_category_types
    content {
      category = enabled_log.value
    }
  }
}

data "azurerm_log_analytics_workspace" "sentinel" {
  provider            = azurerm.platform
  name                = "law-monitoring-eastus2"
  resource_group_name = "rg-monitoring"
}

resource "azurerm_monitor_diagnostic_setting" "afd" {
  name                       = "sentinel"
  target_resource_id         = azurerm_cdn_frontdoor_profile.afd.id
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.sentinel.id

  enabled_log {
    category_group = "allLogs"
  }
}
