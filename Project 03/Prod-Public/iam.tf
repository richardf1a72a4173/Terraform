module "group" {
  source = "../../../Modules/Groups"
  # source = "git::https://<user>@dev.azure.com/<repo>/_git/<repo>//Modules/RF/Groups"
  # source            = "git::https://<user>@dev.azure.com/<repo>/_git/RF//Modules/Groups"
  group_name        = "PERM-${azurerm_resource_group.us.name} - ${var.iam_rbac_role}"
  group_description = "Group providing access to ${azurerm_resource_group.us.name} - ${var.iam_rbac_role}"
  group_members     = var.iam_rbac_member_id
  group_owner       = var.iam_rbac_group_owner
  change_number     = var.group_rbac_change_record
}

/*
data "azuread_user" "Chris" {
  user_principal_name = "chris@example.tld"
}
*/

resource "azurerm_role_assignment" "us" {
  scope                = azurerm_resource_group.us.id
  role_definition_name = var.iam_rbac_role
  principal_id         = trim(module.group.group_id, "/groups/")
}

resource "azurerm_role_assignment" "me" {
  scope                = azurerm_resource_group.us.id
  role_definition_name = "Contributor"
  principal_id         = "00000000-0000-0000-0000-000000000000"
}

resource "azurerm_role_assignment" "website" {
  scope                = azurerm_resource_group.us.id
  role_definition_name = "Website Contributor"
  principal_id         = "00000000-0000-0000-0000-000000000000"
}

resource "azurerm_role_assignment" "storage-me" {
  scope                = azurerm_storage_account.us.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azuread_client_config.current.object_id
}

resource "azurerm_role_assignment" "storage" {
  scope                = azurerm_storage_account.us.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = "00000000-0000-0000-0000-000000000000"
}

resource "azurerm_role_assignment" "managed-1" {
  scope                = azurerm_storage_account.us.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_windows_web_app.us.identity[0].principal_id
}

resource "azurerm_role_assignment" "managed-2" {
  scope                = azurerm_storage_account.us.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_windows_web_app_slot.slot1.identity[0].principal_id
}

resource "azurerm_role_assignment" "managed-3" {
  scope                = azurerm_storage_account.us.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_windows_web_app_slot.slot2.identity[0].principal_id
}

/*
resource "azurerm_role_assignment" "monitorReader" {
  scope                = azurerm_resource_group.us.id
  role_definition_name = "Monitor Reader"
  principal_id         = azuread_user.Chris.object_id
}
*/
