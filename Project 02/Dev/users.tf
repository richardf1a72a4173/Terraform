provider "azuread" {
  alias     = "b2c"
  tenant_id = azurerm_aadb2c_directory.b2c.tenant_id
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "-!"
}

resource "azuread_user" "users" {
  provider = azuread.b2c
  for_each = var.b2c_users

  user_principal_name   = "${each.value.upn}@${azurerm_aadb2c_directory.b2c.domain_name}"
  display_name          = each.value.display_name
  password              = random_password.password.result
  force_password_change = true
  other_mails           = [each.value.mail]

  lifecycle {
    ignore_changes = [password]
  }
}

resource "azuread_directory_role" "ga" {
  provider     = azuread.b2c
  display_name = "Global Administrator"
}

resource "azuread_directory_role_assignment" "ga" {
  provider            = azuread.b2c
  role_id             = azuread_directory_role.ga.template_id
  principal_object_id = azuread_user.users["rod"].object_id
}

resource "azuread_directory_role" "gr" {
  provider     = azuread.b2c
  display_name = "Global Reader"
}

resource "azuread_directory_role" "dr" {
  provider     = azuread.b2c
  display_name = "Directory Readers"
}

resource "azuread_directory_role" "dw" {
  provider     = azuread.b2c
  display_name = "Directory Writers"
}

resource "azuread_directory_role" "flowadmin" {
  provider     = azuread.b2c
  display_name = "External ID User Flow Administrator"
}

resource "azuread_directory_role" "groupadmin" {
  provider     = azuread.b2c
  display_name = "Groups Administrator"
}

resource "azuread_directory_role" "gi" {
  provider     = azuread.b2c
  display_name = "Guest Inviter"
}

resource "azuread_directory_role" "brand" {
  provider     = azuread.b2c
  display_name = "Organizational Branding Administrator"
}

resource "azuread_directory_role" "ua" {
  provider     = azuread.b2c
  display_name = "User Administrator"
}

resource "azuread_directory_role" "caa" {
  provider     = azuread.b2c
  display_name = "Cloud Application Administrator"
}

resource "azuread_directory_role_assignment" "gr" {
  for_each            = toset([azuread_user.users["chris"].object_id, azuread_user.users["michiel"].object_id, azuread_user.users["dimitri"].object_id])
  provider            = azuread.b2c
  role_id             = azuread_directory_role.gr.template_id
  principal_object_id = each.key
}

resource "azuread_directory_role_assignment" "dr" {
  for_each            = toset([azuread_user.users["chris"].object_id, azuread_user.users["michiel"].object_id, azuread_user.users["dimitri"].object_id])
  provider            = azuread.b2c
  role_id             = azuread_directory_role.dr.template_id
  principal_object_id = each.key
}

resource "azuread_directory_role_assignment" "dw" {
  for_each            = toset([azuread_user.users["chris"].object_id, azuread_user.users["michiel"].object_id, azuread_user.users["dimitri"].object_id])
  provider            = azuread.b2c
  role_id             = azuread_directory_role.dw.template_id
  principal_object_id = each.key
}

resource "azuread_directory_role_assignment" "flowadmin" {
  for_each            = toset([azuread_user.users["chris"].object_id, azuread_user.users["michiel"].object_id, azuread_user.users["dimitri"].object_id])
  provider            = azuread.b2c
  role_id             = azuread_directory_role.flowadmin.template_id
  principal_object_id = each.key
}

resource "azuread_directory_role_assignment" "groupadmin" {
  for_each            = toset([azuread_user.users["chris"].object_id, azuread_user.users["michiel"].object_id, azuread_user.users["dimitri"].object_id])
  provider            = azuread.b2c
  role_id             = azuread_directory_role.groupadmin.template_id
  principal_object_id = each.key
}

resource "azuread_directory_role_assignment" "gi" {
  for_each            = toset([azuread_user.users["chris"].object_id, azuread_user.users["michiel"].object_id, azuread_user.users["dimitri"].object_id])
  provider            = azuread.b2c
  role_id             = azuread_directory_role.gi.template_id
  principal_object_id = each.key
}

resource "azuread_directory_role_assignment" "brand" {
  for_each            = toset([azuread_user.users["chris"].object_id, azuread_user.users["michiel"].object_id, azuread_user.users["dimitri"].object_id])
  provider            = azuread.b2c
  role_id             = azuread_directory_role.brand.template_id
  principal_object_id = each.key
}

resource "azuread_directory_role_assignment" "ua" {
  for_each            = toset([azuread_user.users["chris"].object_id, azuread_user.users["michiel"].object_id, azuread_user.users["dimitri"].object_id])
  provider            = azuread.b2c
  role_id             = azuread_directory_role.ua.template_id
  principal_object_id = each.key
}

resource "azuread_directory_role_assignment" "caa" {
  for_each            = toset([azuread_user.users["chris"].object_id, azuread_user.users["michiel"].object_id, azuread_user.users["dimitri"].object_id])
  provider            = azuread.b2c
  role_id             = azuread_directory_role.caa.template_id
  principal_object_id = each.key
}
