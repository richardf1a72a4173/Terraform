resource "azurerm_application_gateway" "appgw" {
  enable_http2                      = true
  fips_enabled                      = false
  firewall_policy_id                = azurerm_web_application_firewall_policy.rg.id
  force_firewall_policy_association = false
  location                          = azurerm_resource_group.rg.location
  name                              = "ag${local.resource_template}001"
  resource_group_name               = azurerm_resource_group.rg.name
  zones                             = ["1", "2", "3"]
  autoscale_configuration {
    max_capacity = 10
    min_capacity = 0
  }
  backend_address_pool {
    fqdns        = []
    ip_addresses = ["${azurerm_container_group.container.ip_address}"]
    name         = "nginx"
  }
  backend_http_settings {
    affinity_cookie_name                = "ApplicationGatewayAffinity"
    cookie_based_affinity               = "Disabled"
    host_name                           = null
    name                                = "nginx-ssl"
    path                                = null
    pick_host_name_from_backend_address = false
    port                                = 80
    probe_name                          = null
    protocol                            = "Http"
    request_timeout                     = 20
    trusted_root_certificate_names      = []
  }
  # private_link_configuration {
  #   name = "plc${local.resource_template}001"
  #   ip_configuration {
  #     name                          = "plc-ip${local.resource_template}001"
  #     private_ip_address_allocation = "Dynamic"
  #     subnet_id                     = azurerm_subnet.subnet[2].id
  #     primary                       = true
  #   }
  # }
  frontend_ip_configuration {
    name                            = "appGwPublicFrontendIpIPv4"
    private_ip_address              = null
    private_ip_address_allocation   = "Dynamic"
    private_link_configuration_name = null
    public_ip_address_id            = azurerm_public_ip.pip.id
    subnet_id                       = null
  }
  frontend_port {
    name = "port_80"
    port = 80
  }
  gateway_ip_configuration {
    name      = "appGatewayIpConfig"
    subnet_id = azurerm_subnet.subnet[0].id
  }
  http_listener {
    firewall_policy_id             = null
    frontend_ip_configuration_name = "appGwPublicFrontendIpIPv4"
    frontend_port_name             = "port_80"
    host_name                      = ""
    host_names                     = []
    name                           = "nginx"
    protocol                       = "Http"
    # require_sni                    = true
    # ssl_certificate_name           = "SSL"
    # ssl_profile_name               = null
  }
  identity {
    identity_ids = ["${azurerm_user_assigned_identity.rg.id}"]
    type         = "UserAssigned"
  }
  #   ssl_certificate {
  #     name = "ssl"
  #     data = base64encode("BEGIN")
  #   }
  request_routing_rule {
    http_listener_name          = "nginx"
    backend_address_pool_name   = "nginx"
    backend_http_settings_name  = "nginx-ssl"
    name                        = "nginx"
    priority                    = 30
    redirect_configuration_name = null
    rewrite_rule_set_name       = null
    rule_type                   = "Basic"
    url_path_map_name           = null
  }
  sku {
    capacity = 0
    name     = "WAF_v2"
    tier     = "WAF_v2"
  }
}

resource "azurerm_web_application_firewall_policy" "rg" {
  location            = azurerm_resource_group.rg.location
  name                = "waf${local.resource_template}001"
  resource_group_name = azurerm_resource_group.rg.name
  tags                = {}
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
}

resource "azurerm_public_ip" "pip" {
  allocation_method       = "Static"
  domain_name_label       = null
  edge_zone               = null
  idle_timeout_in_minutes = 4
  ip_tags                 = {}
  ip_version              = "IPv4"
  location                = azurerm_resource_group.rg.location
  name                    = "pip${local.resource_template}001"
  public_ip_prefix_id     = null
  resource_group_name     = azurerm_resource_group.rg.name
  reverse_fqdn            = null
  sku                     = "Standard"
  sku_tier                = "Regional"
  zones                   = ["1", "2", "3"]
}

resource "azurerm_user_assigned_identity" "rg" {
  location            = azurerm_resource_group.rg.location
  name                = "uai-ag${local.resource_template}001"
  resource_group_name = azurerm_resource_group.rg.name
}
