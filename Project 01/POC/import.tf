import {
  to = azurerm_resource_group.rg
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-emission-waf-p-001"
}

import {
  to = azurerm_virtual_network.rg
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-emission-waf-p-001/providers/Microsoft.Network/virtualNetworks/vnet-emission-waf-p-001"
}

import {
  to = azurerm_key_vault.rg
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-emission-waf-p-001/providers/Microsoft.KeyVault/vaults/kv-emission-waf-p-001"
}

import {
  to = azurerm_application_gateway.rg
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-emission-waf-p-001/providers/Microsoft.Network/applicationGateways/ag-emission-waf-p-001"
}

import {
  to = azurerm_web_application_firewall_policy.rg
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-emission-waf-p-001/providers/Microsoft.Network/applicationGatewayWebApplicationFirewallPolicies/waf-emission-waf-p-001"
}

import {
  to = azurerm_public_ip.rg
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-emission-waf-p-001/providers/Microsoft.Network/publicIPAddresses/pip-emission-waf-p-001"
}

import {
  to = azurerm_user_assigned_identity.rg
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-emission-waf-p-001/providers/Microsoft.ManagedIdentity/userAssignedIdentities/id-emission-waf-p-001"
}

import {
  to = azurerm_subnet.frontend
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-emission-waf-p-001/providers/Microsoft.Network/virtualNetworks/vnet-emission-waf-p-001/subnets/snet-emission-waf-p-001"
}

import {
  to = azurerm_subnet.backend
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-emission-waf-p-001/providers/Microsoft.Network/virtualNetworks/vnet-emission-waf-p-001/subnets/snet-emission-waf-p-002"
}

import {
  to = azurerm_private_endpoint.web
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-emission-waf-p-001/providers/Microsoft.Network/privateEndpoints/pe-stackemissions-p-001"
}

import {
  to = azurerm_private_endpoint.api
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-emission-waf-p-001/providers/Microsoft.Network/privateEndpoints/pe-stackemissionsapi-p-001"
}

import {
  to = azurerm_network_interface.web
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-emission-waf-p-001/providers/Microsoft.Network/networkInterfaces/pe-stackemissions-p-001.nic.00000000-0000-0000-0000-000000000000"
}

import {
  to = azurerm_network_interface.api
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-emission-waf-p-001/providers/Microsoft.Network/networkInterfaces/pe-stackemissionsapi-p-001.nic.00000000-0000-0000-0000-000000000000"
}

import {
  to = azurerm_private_dns_zone.rg
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-emission-waf-p-001/providers/Microsoft.Network/privateDnsZones/privatelink.azurewebsites.net"
}
