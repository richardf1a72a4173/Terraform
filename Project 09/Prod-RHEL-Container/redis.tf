resource "azurerm_redis_cache" "redis" {
  name                 = "redis${local.resource_template}001"
  location             = azurerm_resource_group.rg.location
  resource_group_name  = azurerm_resource_group.rg.name
  capacity             = 2
  family               = "P"
  sku_name             = "Premium"
  non_ssl_port_enabled = false
  minimum_tls_version  = "1.2"

  # subnet_id = azurerm_subnet.redis.id

  redis_configuration {

  }

  lifecycle {
    ignore_changes = [tags]
  }
}
