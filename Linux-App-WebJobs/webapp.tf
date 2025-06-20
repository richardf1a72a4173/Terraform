resource "azurerm_service_plan" "plan" {
  name                = "asp${local.resource_template}001"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "S1"
  os_type             = "Linux"

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

  app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = true
  }

  virtual_network_subnet_id = module.vnet.snet_id

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [tags, site_config, app_settings, sticky_settings, storage_account]
  }
}
