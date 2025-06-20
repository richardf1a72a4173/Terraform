resource "azurerm_container_registry" "myacr" {
  name                = "cr${local.safe_basename}001"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"
  admin_enabled       = false
}

resource "azurerm_container_group" "container" {
  name                = "cg-richard-d-001"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_address_type     = "Private"
  os_type             = "Linux"
  restart_policy      = "Always"
  subnet_ids          = [azurerm_subnet.subnet.id]

  container {
    name   = "container-richard-d-001"
    image  = "phpipam/phpipam-www"
    cpu    = "1"
    memory = "2"

    ports {
      port     = "80"
      protocol = "TCP"
    }

    environment_variables = {
      TZ                 = "Europe/London"
      IPAM_DATABASE_HOST = "localhost"
      IPAM_DATABASE_USER = "ipam"
      IPAM_DATABASE_NAME = "phpipam"
    }

    secure_environment_variables = {
      IPAM_DATABASE_PASS = "<pass>"
    }
  }
  container {
    name   = "container-richard-d-002"
    image  = "mariadb"
    cpu    = "1"
    memory = "2"

    ports {
      port     = "3306"
      protocol = "TCP"
    }

    environment_variables = {
      MARIADB_USER = "ipam"
    }

    secure_environment_variables = {
      MARIADB_PASSWORD = "<pass>"
    }
  }
}
