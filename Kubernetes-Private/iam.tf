resource "azurerm_role_assignment" "private_dns_zone_contributor" {
  principal_id         = azurerm_user_assigned_identity.identity.principal_id
  scope                = azurerm_private_dns_zone.zone.id
  role_definition_name = "Private DNS Zone Contributor"
}

resource "azurerm_role_assignment" "kvmgmt" {
  principal_id         = azurerm_linux_virtual_machine.mgmt.identity[0].principal_id
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets Officer"
}

resource "azurerm_role_assignment" "rf-c-t0" {
  principal_id         = data.azuread_user.rf-c-t0.object_id
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets Officer"
}

resource "azurerm_role_assignment" "kvmgmtc" {
  principal_id         = azurerm_linux_virtual_machine.mgmt.identity[0].principal_id
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Certificates Officer"
}

resource "azurerm_role_assignment" "rf-c-t0c" {
  principal_id         = data.azuread_user.rf-c-t0.object_id
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Certificates Officer"
}
