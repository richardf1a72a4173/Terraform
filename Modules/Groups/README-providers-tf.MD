#Must ensure that the following blocks are provided in your providers

terraform {
  required_providers {
    azuread = {
        source = "hashicorp/azuread"
    }
    version = "2.41.0"
  }
}

provider "azuread" {
  tenant_id = "00000000-0000-0000-0000-000000000000"
  alias = "entraid"
  client_id = ""
  client_certificate_path = ""
  client_certificate_password = ""
}

data "azuread_user" "current_user" {
  object_id = data.azurerm_client_config.current.object_id
}