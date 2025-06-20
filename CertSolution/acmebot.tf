module "keyvault_acmebot" {
  source  = "shibayan/keyvault-acmebot/azurerm"
  version = "~> 3.0"

  app_base_name       = "acmebot-module"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  mail_address        = var.email_address
  vault_uri           = azurerm_key_vault.kv.vault_uri

  allowed_ip_addresses = ["${data.http.myip.response_body}/32"]

  azure_dns = {
    subscription_id = data.azurerm_client_config.current.subscription_id
  }
}