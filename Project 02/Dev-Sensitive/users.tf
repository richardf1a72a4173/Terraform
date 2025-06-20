# provider "azuread" {
#   alias     = "b2c"
#   tenant_id = azurerm_aadb2c_directory.b2c.tenant_id
# }

# resource "random_password" "password" {
#   length           = 16
#   special          = true
#   override_special = "-!"
# }

# Need to manually -target= the users here before anything else applies
# as the data resources need to read the users for role assignment

# resource "azuread_user" "users" {
#   provider = azuread.b2c
#   for_each = var.b2c_users

#   user_principal_name   = "${each.value.upn}@${azurerm_aadb2c_directory.b2c.domain_name}"
#   display_name          = each.value.display_name
#   password              = random_password.password.result
#   force_password_change = true
#   other_mails           = [each.value.mail]

#   lifecycle {
#     ignore_changes = [password]
#   }

#   depends_on = [azurerm_aadb2c_directory.b2c]
# }

# resource "azuread_directory_role" "ga" {
#   provider     = azuread.b2c
#   display_name = "Global Administrator"
# }

# resource "azuread_directory_role_assignment" "ga" {
#   provider            = azuread.b2c
#   role_id             = azuread_directory_role.ga.template_id
#   principal_object_id = azuread_user.users["rod"].object_id
# }

