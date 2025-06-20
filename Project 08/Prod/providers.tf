# Providers

provider "azurerm" {
  subscription_id = var.subscription_id
  features {}

  client_id = "00000000-0000-0000-0000-000000000000" # spn-c-t0.richard.-var
  # client_secret = var.client_secret
  client_certificate_path     = var.client_certificate_path
  client_certificate_password = var.client_certificate_password
  tenant_id                   = "00000000-0000-0000-0000-000000000000"
}

data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

#VWAN Hub Provider
provider "azurerm" {
  alias           = "platform"
  subscription_id = "00000000-0000-0000-0000-000000000000" # Platform
  features {}

  client_id = "00000000-0000-0000-0000-000000000000" # spn-c-t0.richard.-var
  # client_secret = var.client_secret
  client_certificate_path     = var.client_certificate_path
  client_certificate_password = var.client_certificate_password
  tenant_id                   = "00000000-0000-0000-0000-000000000000"
}

provider "azuread" {
  client_id = "00000000-0000-0000-0000-000000000000" # spn-c-t0.richard.-var
  # client_secret = var.client_secret
  client_certificate_path     = var.client_certificate_path
  client_certificate_password = var.client_certificate_password
  tenant_id                   = "00000000-0000-0000-0000-000000000000"
}

provider "time" {}

data "azurerm_virtual_hub" "us" {
  provider            = azurerm.platform
  name                = "vwanh-hub-p-us-001"
  resource_group_name = "rg-vwan-p-eu-001"
}

resource "time_static" "time" {}

data "http" "myip" {
  url = "https://ipinfo.io/ip"
}

data "azurerm_monitor_diagnostic_categories" "categories" {
  count       = length(local.targets_resource_id)
  resource_id = local.targets_resource_id[count.index]
}

data "azurerm_public_ip" "pip" {
  name                = azurerm_public_ip.pip.name
  resource_group_name = azurerm_resource_group.rg.name
}

data "azurerm_dns_zone" "apidomain" {
  provider            = azurerm.platform
  name                = "emt-core.net"
  resource_group_name = "rg-certsol-p-us-001"
}

data "azurerm_key_vault" "certs" {
  provider            = azurerm.platform
  name                = "kv-certsol-p-us-001"
  resource_group_name = "rg-certsol-p-us-001"
}

data "azurerm_key_vault_secret" "ssl" {
  provider     = azurerm.platform
  name         = "${trimprefix(local.resource_template, "-")}001-emt-core-net"
  key_vault_id = data.azurerm_key_vault.certs.id
}

data "azurerm_key_vault_secret" "ssl2" {
  provider     = azurerm.platform
  name         = "${trimprefix(local.resource_template, "-")}002-emt-core-net"
  key_vault_id = data.azurerm_key_vault.certs.id
}

data "azuread_application_published_app_ids" "well_known" {}
