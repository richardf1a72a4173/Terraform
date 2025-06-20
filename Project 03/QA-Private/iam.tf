# Assign RG Permissions
resource "azurerm_role_assignment" "us" {
  scope                = azurerm_resource_group.us.id
  role_definition_name = "Reader"
  principal_id         = var.rg_reader_principal
}