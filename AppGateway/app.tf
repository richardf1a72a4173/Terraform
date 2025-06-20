resource "azurerm_container_group" "container" {
  name                = "cg${local.resource_template}001"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_address_type     = "Private"
  os_type             = "Linux"
  restart_policy      = "Always"
  subnet_ids          = [azurerm_subnet.subnet[1].id]

  container {
    name   = "container${local.resource_template}001"
    image  = "nginx"
    cpu    = "1"
    memory = "2"

    ports {
      port     = "80"
      protocol = "TCP"
    }

    environment_variables = {
      NGINX_PORT = 80
    }
  }

}
