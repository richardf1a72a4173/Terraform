resource "azurerm_virtual_network" "vnet" {
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  name                = local.vnet_name
  address_space       = local.vnet_address
}

resource "azurerm_subnet" "subnet" {
  count = length(local.snet_addresses)

  resource_group_name                           = azurerm_resource_group.rg.name
  name                                          = "snet${local.resource_template}00${count.index + 1}"
  virtual_network_name                          = azurerm_virtual_network.vnet.name
  address_prefixes                              = ["${local.snet_addresses[count.index]}"]
  private_link_service_network_policies_enabled = false

  dynamic "delegation" {
    for_each = count.index == 1 ? [1] : []

    content {
      name = "container"
      service_delegation {
        name = "Microsoft.ContainerInstance/containerGroups"
      }
    }
  }
}
