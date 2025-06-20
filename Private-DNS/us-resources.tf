# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-privatedns-p-us-001/providers/Microsoft.Network/networkSecurityGroups/nsg-snet-privatedns-us-001"
resource "azurerm_network_security_group" "nsg-us-ie" {
  location            = azurerm_resource_group.rg.location
  name                = "nsg-snet-privatedns-us-001"
  resource_group_name = azurerm_resource_group.rg.name
  lifecycle {
    ignore_changes = [tags, security_rule]
  }
}

# __generated__ by Terraform from "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-privatedns-p-us-001/providers/Microsoft.Network/dnsResolvers/pr-privatedns-p-us-001/inboundEndpoints/ie-privatedns-p-us-001"
resource "azurerm_private_dns_resolver_inbound_endpoint" "us-ie" {
  location                = azurerm_resource_group.rg.location
  name                    = "ie-privatedns-p-us-001"
  private_dns_resolver_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-privatedns-p-us-001/providers/Microsoft.Network/dnsResolvers/pr-privatedns-p-us-001"

  ip_configurations {
    private_ip_address           = "10.200.250.4"
    private_ip_allocation_method = "Dynamic"
    subnet_id                    = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-privatedns-p-us-001/providers/Microsoft.Network/virtualNetworks/vnet-privatedns-us-001/subnets/snet-privatedns-us-001"
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

# __generated__ by Terraform from "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-privatedns-p-us-001/providers/Microsoft.Network/networkSecurityGroups/nsg-snet-privatedns-us-002"
resource "azurerm_network_security_group" "nsg-us-oe" {
  location            = azurerm_resource_group.rg.location
  name                = "nsg-snet-privatedns-us-002"
  resource_group_name = azurerm_resource_group.rg.name
  lifecycle {
    ignore_changes = [tags, security_rule]
  }
}

# __generated__ by Terraform from "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-privatedns-p-us-001/providers/Microsoft.Network/virtualNetworks/vnet-privatedns-us-001/subnets/snet-privatedns-us-002"
resource "azurerm_subnet" "us-oe" {
  address_prefixes                              = ["10.200.250.32/27"]
  default_outbound_access_enabled               = true
  name                                          = "snet-privatedns-us-002"
  private_endpoint_network_policies             = "Disabled"
  private_link_service_network_policies_enabled = true
  resource_group_name                           = azurerm_resource_group.rg.name
  virtual_network_name                          = "vnet-privatedns-us-001"
  delegation {
    name = "Microsoft.Network.dnsResolvers"
    service_delegation {
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      name    = "Microsoft.Network/dnsResolvers"
    }
  }
}

# __generated__ by Terraform from "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-privatedns-p-us-001/providers/Microsoft.Network/dnsResolvers/pr-privatedns-p-us-001/outboundEndpoints/oe-privatedns-p-us-001"
resource "azurerm_private_dns_resolver_outbound_endpoint" "us-oe" {
  location                = azurerm_resource_group.rg.location
  name                    = "oe-privatedns-p-us-001"
  private_dns_resolver_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-privatedns-p-us-001/providers/Microsoft.Network/dnsResolvers/pr-privatedns-p-us-001"
  subnet_id               = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-privatedns-p-us-001/providers/Microsoft.Network/virtualNetworks/vnet-privatedns-us-001/subnets/snet-privatedns-us-002"
  lifecycle {
    ignore_changes = [tags]
  }
}

# __generated__ by Terraform
resource "azurerm_virtual_network" "us" {
  address_space       = ["10.200.250.0/26"]
  location            = azurerm_resource_group.rg.location
  name                = "vnet-privatedns-us-001"
  resource_group_name = azurerm_resource_group.rg.name
  lifecycle {
    ignore_changes = [tags]
  }
}

# __generated__ by Terraform from "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-privatedns-p-us-001/providers/Microsoft.Network/dnsResolvers/pr-privatedns-p-us-001"
resource "azurerm_private_dns_resolver" "us" {
  location            = azurerm_resource_group.rg.location
  name                = "pr-privatedns-p-us-001"
  resource_group_name = azurerm_resource_group.rg.name
  lifecycle {
    ignore_changes = [tags]
  }
  virtual_network_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-privatedns-p-us-001/providers/Microsoft.Network/virtualNetworks/vnet-privatedns-us-001"
}

# __generated__ by Terraform from "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-privatedns-p-us-001"
resource "azurerm_resource_group" "rg" {
  location = "eastus2"
  name     = "rg-privatedns-p-us-001"
  lifecycle {
    ignore_changes = [tags]
  }
}

# __generated__ by Terraform from "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-privatedns-p-us-001/providers/Microsoft.Network/virtualNetworks/vnet-privatedns-us-001/subnets/snet-privatedns-us-001"
resource "azurerm_subnet" "us-ie" {
  address_prefixes                              = ["10.200.250.0/27"]
  default_outbound_access_enabled               = true
  name                                          = "snet-privatedns-us-001"
  private_endpoint_network_policies             = "Disabled"
  private_link_service_network_policies_enabled = true
  resource_group_name                           = azurerm_resource_group.rg.name
  virtual_network_name                          = "vnet-privatedns-us-001"
  delegation {
    name = "Microsoft.Network.dnsResolvers"
    service_delegation {
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      name    = "Microsoft.Network/dnsResolvers"
    }
  }
}

# __generated__ by Terraform from "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-privatedns-p-us-001/providers/Microsoft.Network/dnsForwardingRulesets/prr-privatedns-p-us-001"
resource "azurerm_private_dns_resolver_dns_forwarding_ruleset" "us" {
  location                                   = azurerm_resource_group.rg.location
  name                                       = "prr-privatedns-p-us-001"
  private_dns_resolver_outbound_endpoint_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-privatedns-p-us-001/providers/Microsoft.Network/dnsResolvers/pr-privatedns-p-us-001/outboundEndpoints/oe-privatedns-p-us-001"]
  resource_group_name                        = azurerm_resource_group.rg.name
  lifecycle {
    ignore_changes = [tags]
  }
}
