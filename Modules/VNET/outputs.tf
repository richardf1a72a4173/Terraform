output "vnet_id" {
  description = "vNet ID"
  value       = azurerm_virtual_network.vnet.id
}

output "snet_id" {
  description = "SNet ID"
  value       = azurerm_subnet.subnet.id
}

output "vnet_name" {
  description = "vNet Name"
  value = azurerm_virtual_network.vnet.name
}

output "snet_name" {
  description = "SNet Name"
  value = azurerm_subnet.subnet.name
}