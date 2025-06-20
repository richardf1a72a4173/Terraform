resource "azurerm_network_interface" "mgmt" {
  name                = module.naming.network_interface.name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mgmt.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "mgmt" {
  name                = module.naming.virtual_machine.name
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  size                = "Standard_DS2_v2"
  admin_username      = "localuser"
  network_interface_ids = [
    azurerm_network_interface.mgmt.id,
  ]

  admin_ssh_key {
    username   = "localuser"
    public_key = file("./id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Debian"
    offer     = "debian-12"
    sku       = "12"
    version   = "latest"
  }

  identity {
    type = "SystemAssigned"
  }
}
