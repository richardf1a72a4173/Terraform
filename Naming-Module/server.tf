resource "azurerm_network_interface" "rg" {
  count               = 2
  name                = "${module.naming.network_interface.name_unique}-00${count.index + 1}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal-v6"
    subnet_id                     = azurerm_subnet.snet.id
    private_ip_address_allocation = "Dynamic"
    private_ip_address_version    = "IPv6"
  }

  ip_configuration {
    name                          = "internal-v4"
    subnet_id                     = azurerm_subnet.snet.id
    private_ip_address_allocation = "Dynamic"
    private_ip_address_version    = "IPv4"
    primary                       = true
  }
}

resource "azurerm_linux_virtual_machine" "rg" {
  count               = 2
  name                = "${module.naming.linux_virtual_machine.name_unique}-00${count.index + 1}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B2pls_v2"
  admin_username      = "localuser"
  network_interface_ids = [
    azurerm_network_interface.rg[count.index].id,
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
    sku       = "12-arm64"
    version   = "latest"
  }
}
