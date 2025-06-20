resource "azurerm_service_plan" "asp" {
  count                      = 2
  app_service_environment_id = null
  location                   = azurerm_resource_group.rg.location
  name                       = "asp${local.resource_template}00${count.index + 1}"
  resource_group_name        = azurerm_resource_group.rg.name
  os_type                    = "Windows"
  sku_name                   = count.index == 0 ? "P1v3" : "S1"

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_windows_function_app" "fa" {
  count                         = 2
  name                          = "fa${local.resource_template}00${count.index + 1}"
  resource_group_name           = azurerm_resource_group.rg.name
  location                      = azurerm_resource_group.rg.location
  service_plan_id               = azurerm_service_plan.asp[count.index].id
  storage_account_name          = "sa${local.safe_basename}00${count.index + 1}"
  virtual_network_subnet_id     = azurerm_subnet.app.id
  public_network_access_enabled = false
  https_only                    = true

  site_config {

  }

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [tags]
  }
}
