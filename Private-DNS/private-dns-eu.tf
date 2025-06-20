resource "azurerm_private_dns_resolver" "eu" {
  location            = var.region2
  name                = local.eu_privdns_name
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_id  = azurerm_virtual_network.eu.id

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_private_dns_resolver_outbound_endpoint" "eu-oe" {
  location                = var.region2
  name                    = local.eu_oe_name
  private_dns_resolver_id = azurerm_private_dns_resolver.eu.id
  subnet_id               = azurerm_subnet.eu-subnet[1].id

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_private_dns_resolver_inbound_endpoint" "eu-ie" {
  location                = var.region2
  name                    = local.eu_ie_name
  private_dns_resolver_id = azurerm_private_dns_resolver.eu.id

  ip_configurations {
    subnet_id = azurerm_subnet.eu-subnet[0].id
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_private_dns_resolver_dns_forwarding_ruleset" "eu" {
  location                                   = var.region2
  name                                       = local.eu_ruleset_name
  private_dns_resolver_outbound_endpoint_ids = [azurerm_private_dns_resolver_outbound_endpoint.eu-oe.id]
  resource_group_name                        = azurerm_resource_group.rg.name
  lifecycle {
    ignore_changes = [tags]
  }
}