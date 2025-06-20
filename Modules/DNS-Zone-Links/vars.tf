variable "vnet_name" {
  description = "The name of your VNET being linked"
  type        = string
}

variable "private_dns_zone_rg_name" {
  description = "The private DNS zone resource group"
  default     = "rg-privatedns-p-us-001"
  type        = string
}

variable "virtual_network_id" {
  description = "The VNET ID of your VNET"
  type        = string
}

variable "dns_zones" {
  description = "The Private DNS Zones to be linked"
  type = map(object({
    short_name = string
    name       = string
  }))
  default = {
    azurewebsites = {
      short_name = "azurewebsites"
      name       = "privatelink.azurewebsites.net"
    }
    blob = {
      short_name = "blob"
      name       = "privatelink.blob.core.windows.net"
    }
    database = {
      short_name = "database"
      name       = "privatelink.database.windows.net"
    }
    file = {
      short_name = "file"
      name       = "privatelink.file.core.windows.net"
    }
    mysql = {
      short_name = "mysql"
      name       = "privatelink.mysql.database.azure.com"
    }
    vaultcore = {
      short_name = "vaultcore"
      name       = "privatelink.vaultcore.azure.net"
    }
    redis = {
      short_name = "redis"
      name       = "privatelink.redis.cache.windows.net"
    }
    acr = {
      short_name = "acr"
      name       = "privatelink.azurecr.io"
    }
    servicebus = {
      short_name = "servicebus"
      name       = "privatelink.servicebus.windows.net"
    }
    configuration = {
      short_name = "configuration"
      name       = "privatelink.azconfig.io"
    }
  }
}
