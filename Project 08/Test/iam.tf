module "group" {
  source            = "../../../Modules/Groups"
  group_name        = "PERM-${azurerm_resource_group.rg.name} - ${var.iam_rbac_role}"
  group_description = "Group providing access to ${azurerm_resource_group.rg.name} - ${var.iam_rbac_role}"
  group_members     = var.iam_rbac_member_id
  group_owner       = var.iam_rbac_group_owner
  change_number     = var.group_rbac_change_record
}

resource "azurerm_role_assignment" "rg" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = var.iam_rbac_role
  principal_id         = trim(module.group.group_id, "/groups/")
}

resource "azurerm_role_assignment" "rg-rf" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Contributor"
  principal_id         = var.iam_rbac_group_owner
}

resource "azurerm_role_assignment" "kv-spn" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "kv" {
  for_each             = var.iam_rbac_member_id
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = each.value
}

resource "azurerm_role_assignment" "storage-1" {
  for_each             = var.iam_rbac_member_id
  scope                = azurerm_storage_account.storage[0].id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = each.value
}

resource "azurerm_role_assignment" "storage-2" {
  for_each             = var.iam_rbac_member_id
  scope                = azurerm_storage_account.storage[1].id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = each.value
}

resource "azurerm_role_assignment" "logicapps-1" {
  for_each             = var.iam_rbac_member_id
  scope                = azurerm_logic_app_standard.la[0].id
  role_definition_name = "Website Contributor"
  principal_id         = each.value
}

resource "azurerm_role_assignment" "logicapps-2" {
  for_each             = var.iam_rbac_member_id
  scope                = azurerm_logic_app_standard.la[1].id
  role_definition_name = "Website Contributor"
  principal_id         = each.value
}

resource "azurerm_role_assignment" "sb" {
  for_each             = var.iam_rbac_member_id
  scope                = azurerm_servicebus_namespace.namespace.id
  role_definition_name = "Azure Service Bus Data Owner"
  principal_id         = each.value
}

resource "azurerm_role_assignment" "la-sb" {
  scope                = azurerm_servicebus_namespace.namespace.id
  role_definition_name = "Azure Service Bus Data Owner"
  principal_id         = azurerm_logic_app_standard.la[0].identity[0].principal_id
}

resource "azurerm_role_assignment" "la-kv" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = azurerm_logic_app_standard.la[1].identity[0].principal_id
}

resource "azurerm_role_assignment" "la-sb-read" {
  scope                = azurerm_servicebus_namespace.namespace.id
  role_definition_name = "Azure Service Bus Data Receiver"
  principal_id         = azurerm_logic_app_standard.la[1].identity[0].principal_id
}

resource "azurerm_role_assignment" "rg-website-contributor" {
  for_each             = var.iam_rbac_member_id
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Website Contributor"
  principal_id         = each.value
}

resource "azurerm_role_assignment" "rg-logic-app-contributor" {
  for_each             = var.iam_rbac_member_id
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Logic App Contributor"
  principal_id         = each.value
}

resource "azurerm_role_assignment" "la-storage-contributor-1" {
  scope                = azurerm_storage_account.storage[0].id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_logic_app_standard.la[0].identity[0].principal_id
}

resource "azurerm_role_assignment" "la-storage-contributor-2" {
  scope                = azurerm_storage_account.storage[1].id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_logic_app_standard.la[1].identity[0].principal_id
}

resource "azurerm_key_vault_access_policy" "dev-cert-kv" {
  key_vault_id = data.azurerm_key_vault.certs.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.ag.principal_id

  certificate_permissions = [
    "Get",
    "List",
  ]

  secret_permissions = [
    "Get",
    "List",
  ]
}
