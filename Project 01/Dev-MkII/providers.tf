# Providers

provider "azurerm" {
  subscription_id = var.subscription_id
  features {}

  client_id = "00000000-0000-0000-0000-000000000000"
  # client_secret = var.client_secret
  client_certificate_path     = var.client_certificate_path
  client_certificate_password = var.client_certificate_password
  tenant_id                   = "00000000-0000-0000-0000-000000000000"
}

data "azurerm_client_config" "current" {}

#VWAN Hub Provider
provider "azurerm" {
  alias           = "platform"
  subscription_id = "00000000-0000-0000-0000-000000000000"
  features {}

  client_id = "00000000-0000-0000-0000-000000000000"
  # client_secret = var.client_secret
  client_certificate_path     = var.client_certificate_path
  client_certificate_password = var.client_certificate_password
  tenant_id                   = "00000000-0000-0000-0000-000000000000"
}

provider "time" {}

data "azurerm_virtual_hub" "eu" {
  provider            = azurerm.platform
  name                = "vwanh-hub-p-eu-001"
  resource_group_name = "rg-vwan-p-eu-001"
}

resource "time_static" "time" {}

data "http" "myip" {
  url = "https://ipinfo.io/ip"
}

data "azurerm_dns_zone" "devdns" {
  provider            = azurerm.platform
  name                = "<domain>.net"
  resource_group_name = "rg-certsol-p-us-001"
}

data "azurerm_key_vault" "certs" {
  provider            = azurerm.platform
  name                = "kv-certsol-p-us-001"
  resource_group_name = "rg-certsol-p-us-001"
}

data "azurerm_key_vault_secret" "ssl" {
  provider     = azurerm.platform
  name         = "project01-d-weu-001-<domain>-net"
  key_vault_id = data.azurerm_key_vault.certs.id
}

data "azurerm_key_vault_secret" "ssl2" {
  provider     = azurerm.platform
  name         = "project01-d-weu-002-<domain>-net"
  key_vault_id = data.azurerm_key_vault.certs.id
}

data "azurerm_monitor_diagnostic_categories" "categories" {
  count       = length(local.targets_resource_id)
  resource_id = local.targets_resource_id[count.index]
}

data "azurerm_public_ip" "pip" {
  name                = azurerm_public_ip.pip.name
  resource_group_name = azurerm_resource_group.rg.name
}
