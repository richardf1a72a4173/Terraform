# resource "azuread_application_registration" "appreg" {
#   display_name = "app-reg-${local.resource_template}"
# }

# resource "azuread_application_api_access" "api_access" {
#   application_id = azuread_application_registration.appreg.id
#   api_client_id  = data.azuread_application_published_app_ids.well_known.result["MicrosoftGraph"]

#   role_ids = [
#     "00000000-0000-0000-0000-000000000000", # User.Read.All
#   ]

# }

# resource "azuread_application_owner" "app_owner" {
#   application_id  = azuread_application_registration.appreg.id
#   owner_object_id = data.azurerm_client_config.current.object_id
# }

# resource "azuread_application_password" "app_password" {
#   application_id = azuread_application_registration.appreg.id
# }
