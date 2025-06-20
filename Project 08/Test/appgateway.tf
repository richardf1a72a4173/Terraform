resource "azurerm_user_assigned_identity" "ag" {
  name                = "${module.naming.application_gateway.name}-uai"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_web_application_firewall_policy" "waf" {
  name                = "${module.naming.application_gateway.name}-waf"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  managed_rules {
    managed_rule_set {
      type    = "OWASP"
      version = jsonencode(3.2)
    }
  }
  policy_settings {
    enabled                     = true
    file_upload_limit_in_mb     = 100
    max_request_body_size_in_kb = 128
    mode                        = "Detection"
    request_body_check          = true
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_application_gateway" "ag" {
  name                = module.naming.application_gateway.name
  resource_group_name = azurerm_resource_group.rg.name
  enable_http2        = true
  fips_enabled        = false
  firewall_policy_id  = azurerm_web_application_firewall_policy.waf.id
  location            = azurerm_resource_group.rg.location
  zones               = ["1", "2", "3"]
  autoscale_configuration {
    max_capacity = local.env == "p" ? 5 : 2
    min_capacity = local.env == "p" ? 2 : 0
  }
  backend_address_pool {
    fqdns        = [azurerm_logic_app_standard.la[0].default_hostname]
    ip_addresses = []
    name         = "app-backendpool${local.resource_template}001"
  }
  backend_address_pool {
    fqdns        = [azurerm_logic_app_standard.la[1].default_hostname]
    ip_addresses = []
    name         = "app-backendpool${local.resource_template}002"
  }
  backend_http_settings {
    affinity_cookie_name                = "ApplicationGatewayAffinity"
    cookie_based_affinity               = "Disabled"
    host_name                           = null
    name                                = "backend-httpsettings-app${local.resource_template}001"
    path                                = null
    pick_host_name_from_backend_address = true
    port                                = 443
    probe_name                          = null
    protocol                            = "Https"
    request_timeout                     = 600
    trusted_root_certificate_names      = []
  }
  # Public Frontend
  frontend_ip_configuration {
    name                            = "ag-fe-pub${local.resource_template}001"
    private_ip_address              = null
    private_ip_address_allocation   = "Dynamic"
    private_link_configuration_name = null
    public_ip_address_id            = azurerm_public_ip.pip.id
    subnet_id                       = null
  }
  # # Private Frontend
  # frontend_ip_configuration {
  #   name                          = "appGwPrivateFrontendIpIPv4"
  #   private_ip_address            = "10.201.10.30"
  #   private_ip_address_allocation = "Static"
  #   subnet_id                     = azurerm_subnet.app-gw.id
  # }
  frontend_port {
    name = "port_443"
    port = 443
  }
  frontend_port {
    name = "port_80"
    port = 80
  }
  gateway_ip_configuration {
    name      = "appGatewayIpConfig"
    subnet_id = azurerm_subnet.snets[0].id
  }
  # Public Listeners
  http_listener {
    firewall_policy_id             = null
    frontend_ip_configuration_name = "ag-fe-pub${local.resource_template}001"
    frontend_port_name             = "port_443"
    host_name                      = trimsuffix(azurerm_dns_a_record.dns-pip[0].fqdn, ".")
    host_names                     = null
    name                           = "https-listener-app${local.resource_template}001"
    protocol                       = "Https"
    require_sni                    = true
    ssl_certificate_name           = data.azurerm_key_vault_secret.ssl.name
    ssl_profile_name               = null
  }
  http_listener {
    firewall_policy_id             = null
    frontend_ip_configuration_name = "ag-fe-pub${local.resource_template}001"
    frontend_port_name             = "port_443"
    host_name                      = trimsuffix(azurerm_dns_a_record.dns-pip[1].fqdn, ".")
    host_names                     = null
    name                           = "https-listener-app${local.resource_template}002"
    protocol                       = "Https"
    require_sni                    = true
    ssl_certificate_name           = data.azurerm_key_vault_secret.ssl2.name
    ssl_profile_name               = null
  }
  http_listener {
    firewall_policy_id             = null
    frontend_ip_configuration_name = "ag-fe-pub${local.resource_template}001"
    frontend_port_name             = "port_80"
    host_name                      = trimsuffix(azurerm_dns_a_record.dns-pip[0].fqdn, ".")
    host_names                     = null
    name                           = "http-listener-app${local.resource_template}001"
    protocol                       = "Http"
  }
  http_listener {
    firewall_policy_id             = null
    frontend_ip_configuration_name = "ag-fe-pub${local.resource_template}001"
    frontend_port_name             = "port_80"
    host_name                      = trimsuffix(azurerm_dns_a_record.dns-pip[1].fqdn, ".")
    host_names                     = null
    name                           = "http-listener-app${local.resource_template}002"
    protocol                       = "Http"
  }
  # *** ------------------- ***
  identity {
    identity_ids = [azurerm_user_assigned_identity.ag.id]
    type         = "UserAssigned"
  }
  ssl_certificate {
    name                = data.azurerm_key_vault_secret.ssl.name
    key_vault_secret_id = data.azurerm_key_vault_secret.ssl.versionless_id
  }
  ssl_certificate {
    name                = data.azurerm_key_vault_secret.ssl2.name
    key_vault_secret_id = data.azurerm_key_vault_secret.ssl2.versionless_id
  }
  request_routing_rule {
    backend_address_pool_name   = "app-backendpool${local.resource_template}001"
    backend_http_settings_name  = "backend-httpsettings-app${local.resource_template}001"
    http_listener_name          = "https-listener-app${local.resource_template}001"
    name                        = "https-rrr-app${local.resource_template}001"
    priority                    = 30
    redirect_configuration_name = null
    rewrite_rule_set_name       = null
    rule_type                   = "Basic"
    url_path_map_name           = null
  }
  request_routing_rule {
    backend_address_pool_name   = "app-backendpool${local.resource_template}002"
    backend_http_settings_name  = "backend-httpsettings-app${local.resource_template}001"
    http_listener_name          = "https-listener-app${local.resource_template}002"
    name                        = "https-rrr-app${local.resource_template}002"
    priority                    = 31
    redirect_configuration_name = null
    rewrite_rule_set_name       = null
    rule_type                   = "Basic"
    url_path_map_name           = null
  }
  # HTTPS Automatic Upgrade
  request_routing_rule {
    http_listener_name          = "http-listener-app${local.resource_template}001"
    name                        = "http-rrr-app${local.resource_template}001"
    priority                    = 20
    redirect_configuration_name = "http-rrr-app${local.resource_template}001"
    rewrite_rule_set_name       = null
    rule_type                   = "Basic"
    url_path_map_name           = null
  }
  redirect_configuration {
    name                 = "http-rrr-app${local.resource_template}001"
    include_path         = true
    include_query_string = true
    redirect_type        = "Permanent"
    target_listener_name = "https-listener-app${local.resource_template}001"
  }
  request_routing_rule {
    http_listener_name          = "http-listener-app${local.resource_template}002"
    name                        = "http-rrr-app${local.resource_template}002"
    priority                    = 21
    redirect_configuration_name = "http-rrr-app${local.resource_template}002"
    rewrite_rule_set_name       = null
    rule_type                   = "Basic"
    url_path_map_name           = null
  }
  redirect_configuration {
    name                 = "http-rrr-app${local.resource_template}002"
    include_path         = true
    include_query_string = true
    redirect_type        = "Permanent"
    target_listener_name = "https-listener-app${local.resource_template}002"
  }
  sku {
    capacity = 0
    name     = "WAF_v2"
    tier     = "WAF_v2"
  }

  lifecycle {
    ignore_changes = [tags]
  }
}
