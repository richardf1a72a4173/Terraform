import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-privatedns-p-us-001"
  to = azurerm_resource_group.rg
}

import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-privatedns-p-us-001/providers/Microsoft.Network/virtualNetworks/vnet-privatedns-us-001"
  to = azurerm_virtual_network.us
}

import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-privatedns-p-us-001/providers/Microsoft.Network/virtualNetworks/vnet-privatedns-us-001/subnets/snet-privatedns-us-001"
  to = azurerm_subnet.us-ie
}

import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-privatedns-p-us-001/providers/Microsoft.Network/virtualNetworks/vnet-privatedns-us-001/subnets/snet-privatedns-us-002"
  to = azurerm_subnet.us-oe
}

import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-privatedns-p-us-001/providers/Microsoft.Network/networkSecurityGroups/nsg-snet-privatedns-us-001"
  to = azurerm_network_security_group.nsg-us-ie
}

import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-privatedns-p-us-001/providers/Microsoft.Network/networkSecurityGroups/nsg-snet-privatedns-us-002"
  to = azurerm_network_security_group.nsg-us-oe
}

import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-privatedns-p-us-001/providers/Microsoft.Network/dnsResolvers/pr-privatedns-p-us-001"
  to = azurerm_private_dns_resolver.us
}

import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-privatedns-p-us-001/providers/Microsoft.Network/dnsForwardingRulesets/prr-privatedns-p-us-001"
  to = azurerm_private_dns_resolver_dns_forwarding_ruleset.us
}

import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-privatedns-p-us-001/providers/Microsoft.Network/dnsResolvers/pr-privatedns-p-us-001/inboundEndpoints/ie-privatedns-p-us-001"
  to = azurerm_private_dns_resolver_inbound_endpoint.us-ie
}

import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-privatedns-p-us-001/providers/Microsoft.Network/dnsResolvers/pr-privatedns-p-us-001/outboundEndpoints/oe-privatedns-p-us-001"
  to = azurerm_private_dns_resolver_outbound_endpoint.us-oe
}
