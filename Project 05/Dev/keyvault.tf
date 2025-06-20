resource "azurerm_key_vault" "kv" {
  location                        = azurerm_resource_group.rg.location
  resource_group_name             = azurerm_resource_group.rg.name
  name                            = "kv${local.resource_template}001"
  sku_name                        = "premium"
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  enable_rbac_authorization       = true
  enabled_for_template_deployment = true
  public_network_access_enabled   = true

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
    ip_rules       = [data.http.myip.response_body]
    virtual_network_subnet_ids = [
      azurerm_subnet.snets[0].id,
      azurerm_subnet.snets[1].id,
      azurerm_subnet.snets[2].id,
    ]
  }

  lifecycle {
    ignore_changes = [tags, network_acls]
  }
}
