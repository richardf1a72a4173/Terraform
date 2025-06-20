resource "azurerm_service_plan" "plan" {
  name                = "asp${local.resource_template}001"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "B1"
  os_type             = "Linux"

  lifecycle {
    ignore_changes = [tags]
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

  }

  lifecycle {
    ignore_changes = [tags]
  }

}
