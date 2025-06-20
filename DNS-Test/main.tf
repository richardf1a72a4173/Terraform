# Configure
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.29.0"
    }
  }

  required_version = ">= 1.7.0"
}

provider "azurerm" {
  subscription_id = "00000000-0000-0000-0000-000000000000" #Platform
  features {}
}

locals {
  prefix      = "dnstest-d"
  rg_name     = "rg-${local.prefix}-001"
  rg_location = "eastus2"

  tags = {
    "Environment"      = "Dev"
    "Active Directory" = "n/a"
    "Application Name" = "Development"
    "Confidentiality"  = "n/a"
    "Cost Centre"      = "GTS"
    "Operations Team"  = "Azure Engineering"
    "Project"          = "n/a"
    "Region"           = "East US 2"
    "Service Hours"    = "n/a"
    "Service Level"    = "n/a"
    "Tooling"          = "Terraform"
  }
}

resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = local.rg_location
  tags     = local.tags
}

#resource "azurerm_virtual_network" "rg" {
#  name                = "vnet-${local.prefix}-001"
#  location            = azurerm_resource_group.rg.location
#  resource_group_name = azurerm_resource_group.rg.name
#  address_space       = ["10.200.250.64/27"]
#}

#resource "azurerm_subnet" "rg" {
#  name                 = "snet-${local.prefix}-001"
#  resource_group_name  = azurerm_resource_group.rg.name
#  virtual_network_name = azurerm_virtual_network.rg.name
#  address_prefixes     = ["10.200.250.64/27"]
#}

module "vnet" {
  source       = "../Modules/VNET"
  rg_name      = azurerm_resource_group.rg.name
  location     = azurerm_resource_group.rg.location
  vnet_name    = "vnet-${local.prefix}-001"
  vnet_address = "10.200.250.64/27"
  snet_name    = "snet-${local.prefix}-001"
  snet_address = "10.200.250.64/27"
}

resource "azurerm_network_security_group" "rg" {
  name                = "nsg-snet-${local.prefix}-001"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_interface" "rg" {
  name                = "nic-azus-${local.prefix}-001"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.vnet.snet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "rg" {
  name                = "azus-${local.prefix}-001"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B2pls_v2"
  admin_username      = "localuser"
  network_interface_ids = [
    azurerm_network_interface.rg.id,
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

# Bastion peering

module "peer_bastion" {
  source              = "../Modules/Peering"
  rg_name             = azurerm_resource_group.rg.name
  remote_rg_name      = "rg-conn-p-us-001"
  from_remote_vnet_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-conn-p-us-001/providers/Microsoft.Network/virtualNetworks/vnet-bas-p-us-001"
  from_vnet_name      = module.vnet.vnet_name
  from_vnet_peer_name = "peer-vnet-${local.prefix}-001-to-vnet-bas-p-us-001"
  to_vnet_peer_name   = "peer-vnet-bas-p-us-001-to-vnet-${local.prefix}-001"
  to_vnet_name        = "vnet-bas-p-us-001"
  to_remote_vnet_id   = module.vnet.vnet_id

  depends_on = [module.vnet]
}

# Private DNS Peering

module "peer_DNS" {
  source              = "../Modules/Peering"
  rg_name             = azurerm_resource_group.rg.name
  remote_rg_name      = "rg-privatedns-p-us-001"
  from_remote_vnet_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-privatedns-p-us-001/providers/Microsoft.Network/virtualNetworks/vnet-privatedns-us-001"
  from_vnet_name      = module.vnet.vnet_name
  from_vnet_peer_name = "peer-vnet-${local.prefix}-001-to-vnet-privatedns-p-us-001"
  to_vnet_peer_name   = "peer-vnet-privatedns-p-us-001-to-vnet-${local.prefix}-001"
  to_vnet_name        = "vnet-privatedns-us-001"
  to_remote_vnet_id   = module.vnet.vnet_id

  depends_on = [module.vnet]
}

#resource "azurerm_virtual_network_peering" "vnet_to_bastion" {
#  name                      = "peer-vnet-${local.prefix}-001-to-vnet-bas-p-us-001"
#  resource_group_name       = azurerm_resource_group.rg.name
#  virtual_network_name      = module.vnet.vnet_name
#  remote_virtual_network_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-conn-p-us-001/providers/Microsoft.Network/virtualNetworks/vnet-bas-p-us-001"
#}

#resource "azurerm_virtual_network_peering" "bastion_to_vnet" {
#  name                      = "peer-vnet-bas-p-us-001-to-vnet-${local.prefix}-001"
#  resource_group_name       = "rg-conn-p-us-001"
#  virtual_network_name      = "vnet-bas-p-us-001"
#  remote_virtual_network_id = module.vnet.vnet_id
#}

# Private DNS Peering

#resource "azurerm_virtual_network_peering" "vnet_to_dns" {
#  name                      = "peer-vnet-${local.prefix}-001-to-vnet-privatedns-p-us-001"
#  resource_group_name       = azurerm_resource_group.rg.name
#  virtual_network_name      = module.vnet.vnet_name
#  remote_virtual_network_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-privatedns-p-us-001/providers/Microsoft.Network/virtualNetworks/vnet-privatedns-us-001"
#}

#resource "azurerm_virtual_network_peering" "dns_to_vnet" {
#  name                      = "peer-vnet-privatedns-p-us-001-to-vnet-${local.prefix}-001"
#  resource_group_name       = "rg-privatedns-p-us-001"
#  virtual_network_name      = "vnet-privatedns-us-001"
#  remote_virtual_network_id = module.vnet.vnet_id
#}
