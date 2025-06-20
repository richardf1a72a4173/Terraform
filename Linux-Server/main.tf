# Configure
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.29.0"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  subscription_id = "00000000-0000-0000-0000-000000000000"
  tenant_id       = "00000000-0000-0000-0000-000000000000"
  client_id       = "00000000-0000-0000-0000-000000000000"
  client_secret   = ""
  features {}
}

locals {
  rg_name     = "rg-richard-d-001"
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

resource "azurerm_virtual_network" "rg" {
  name                = "vnet-richard-d-us-001"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["172.31.201.0/24"]
}

resource "azurerm_subnet" "rg" {
  name                 = "snet-richard-d-us-001"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.rg.name
  address_prefixes     = ["172.31.201.0/24"]

}

resource "azurerm_network_security_group" "rg" {
  name                = "nsg-snet-richard-d-us-001"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_interface" "rg" {
  name                = "nic-azus-richard-d-us-001"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.rg.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "rg" {
  name                = "azus-richard-d-us-001"
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
