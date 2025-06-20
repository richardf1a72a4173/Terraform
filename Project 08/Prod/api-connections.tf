resource "azurerm_api_connection" "sendgrid" {
  name                = "${module.naming.api_management.name}-sendgrid"
  resource_group_name = azurerm_resource_group.rg.name
  display_name        = "SendGridTest"
  managed_api_id      = "/subscriptions/${var.subscription_id}/providers/Microsoft.Web/locations/${azurerm_resource_group.rg.location}/managedApis/sendgrid"

  parameter_values = {

  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_api_connection" "ax-1" {
  name                = "${module.naming.api_management.name}-ax-1"
  resource_group_name = azurerm_resource_group.rg.name
  managed_api_id      = "/subscriptions/${var.subscription_id}/providers/Microsoft.Web/locations/${azurerm_resource_group.rg.location}/managedApis/dynamicsax"

  parameter_values = {

  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_api_connection" "ax-2" {
  name                = "${module.naming.api_management.name}-ax-2"
  resource_group_name = azurerm_resource_group.rg.name
  managed_api_id      = "/subscriptions/${var.subscription_id}/providers/Microsoft.Web/locations/${azurerm_resource_group.rg.location}/managedApis/dynamicsax"

  parameter_values = {

  }

  lifecycle {
    ignore_changes = [tags]
  }
}
