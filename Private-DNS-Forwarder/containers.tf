resource "azurerm_container_registry" "myacr" {
  name                = "cr${local.safe_basename}001"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"
  admin_enabled       = false

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_container_group" "container" {
  name                = "cg${local.resource_template}001"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_address_type     = "Private"
  os_type             = "Linux"
  restart_policy      = "Never"
  subnet_ids          = [azurerm_subnet.us.id]

  container {
    name   = "container${local.resource_template}001"
    image  = "pschiffe/pdns-recursor:latest"
    cpu    = "1"
    memory = "2"

    ports {
      port     = "53"
      protocol = "TCP"
    }

    environment_variables = {
      # PDNS_gmysql_host       = "${azurerm_mysql_flexible_server.db.fqdn}"
      # PDNS_gmysql_port       = "3306"
      # PDNS_gmysql_user       = "${azurerm_mysql_flexible_server.db.administrator_login}"
      # PDNS_gmysql_dbname     = "powerdns"
      PDNS_webserver         = "yes"
      PDNS_webserver_address = "0.0.0.0"
    }

    secure_environment_variables = {
      # PDNS_gmysql_password    = "${azurerm_mysql_flexible_server.db.administrator_password}"
      PDNS_webserver_password = "<pass>"
      PDNS_api_key            = "<pass>"
    }
  }

  # container {
  #   name   = "container${local.resource_template}002"
  #   image  = "powerdnsadmin/pda-legacy:latest"
  #   cpu    = "1"
  #   memory = "2"

  #   ports {
  #     port     = "80"
  #     protocol = "TCP"
  #   }

  #   environment_variables = {
  #     SALT                    = ""
  #     SECRET_KEY              = ""
  #     PORT                    = "80"
  #     SQLALCHEMY_DATABASE_URI = "mysql://${azurerm_mysql_flexible_server.db.administrator_login}:${azurerm_mysql_flexible_server.db.administrator_password}@${azurerm_mysql_flexible_server.db.fqdn}/powerdnsadmin"
  #   }
  # }

  image_registry_credential {
    username = "<user>"
    password = "<pass>"
    server   = "docker.io"
  }

  timeouts {
    create = "60m"
  }

  depends_on = [azurerm_virtual_network.us, azurerm_subnet.us, module.dns_links]
}
