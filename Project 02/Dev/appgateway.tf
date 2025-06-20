resource "azurerm_user_assigned_identity" "ag" {
  name                = local.ag_mi_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_web_application_firewall_policy" "waf" {
  name                = local.waf_name
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
  enable_http2        = true
  fips_enabled        = false
  firewall_policy_id  = azurerm_web_application_firewall_policy.waf.id
  location            = azurerm_resource_group.rg.location
  name                = local.ag_name
  resource_group_name = azurerm_resource_group.rg.name
  zones               = ["1", "2", "3"]
  autoscale_configuration {
    max_capacity = 2
    min_capacity = 0
  }
  backend_address_pool {
    fqdns        = ["app-project02-d-us-001.azurewebsites.net"]
    ip_addresses = []
    name         = "app-backendpool-project02-d-us-001"
  }
  backend_http_settings {
    affinity_cookie_name                = "ApplicationGatewayAffinity"
    cookie_based_affinity               = "Disabled"
    host_name                           = null
    name                                = "backend-httpsettings-app-project02-d-us-001"
    path                                = null
    pick_host_name_from_backend_address = true
    port                                = 443
    probe_name                          = null
    protocol                            = "Https"
    request_timeout                     = 20
    trusted_root_certificate_names      = []
  }
  frontend_ip_configuration {
    name                            = "appGwPublicFrontendIpIPv4"
    private_ip_address              = null
    private_ip_address_allocation   = "Dynamic"
    private_link_configuration_name = null
    public_ip_address_id            = azurerm_public_ip.pip.id
    subnet_id                       = null
  }
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
    subnet_id = azurerm_subnet.app-gw.id
  }
  http_listener {
    firewall_policy_id             = null
    frontend_ip_configuration_name = "appGwPublicFrontendIpIPv4"
    frontend_port_name             = "port_443"
    host_name                      = local.app_hostname
    host_names                     = []
    name                           = "https-listener-app-project02-d-us-001"
    protocol                       = "Https"
    require_sni                    = true
    ssl_certificate_name           = "project02-d-us-001-<domain>-net"
    ssl_profile_name               = null
  }
  http_listener {
    firewall_policy_id             = null
    frontend_ip_configuration_name = "appGwPublicFrontendIpIPv4"
    frontend_port_name             = "port_80"
    host_name                      = local.app_hostname
    host_names                     = []
    name                           = "http-listener-app-project02-d-us-001"
    protocol                       = "Http"
  }
  identity {
    identity_ids = ["${azurerm_user_assigned_identity.ag.id}"]
    type         = "UserAssigned"
  }
  ssl_certificate {
    key_vault_secret_id = data.azurerm_key_vault_secret.ssl.id
    name                = "project02-d-us-001-qb3rh6ep9j-net"
  }
  request_routing_rule {
    backend_address_pool_name   = "app-backendpool-project02-d-us-001"
    backend_http_settings_name  = "backend-httpsettings-app-project02-d-us-001"
    http_listener_name          = "https-listener-app-project02-d-us-001"
    name                        = "https-rrr-app-project02-d-us-001"
    priority                    = 30
    redirect_configuration_name = null
    rewrite_rule_set_name       = null
    rule_type                   = "Basic"
    url_path_map_name           = null
  }
  # HTTPS Automatic Upgrade
  request_routing_rule {
    http_listener_name          = "http-listener-app-project02-d-us-001"
    name                        = "http-rrr-app-project02-d-us-001"
    priority                    = 20
    redirect_configuration_name = "http-rrr-app-project02-d-us-001"
    rewrite_rule_set_name       = null
    rule_type                   = "Basic"
    url_path_map_name           = null
  }
  redirect_configuration {
    name                 = "http-rrr-app-project02-d-us-001"
    include_path         = true
    include_query_string = true
    redirect_type        = "Permanent"
    target_listener_name = "https-listener-app-project02-d-us-001"
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
