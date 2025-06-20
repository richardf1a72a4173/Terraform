resource "azurerm_virtual_network_peering" "from" {
  name                      = var.from_vnet_peer_name
  resource_group_name       = var.rg_name
  virtual_network_name      = var.from_vnet_name
  remote_virtual_network_id = var.from_remote_vnet_id
}

resource "azurerm_virtual_network_peering" "to" {
  name                      = var.to_vnet_peer_name
  resource_group_name       = var.remote_rg_name
  virtual_network_name      = var.to_vnet_name
  remote_virtual_network_id = var.to_remote_vnet_id
}