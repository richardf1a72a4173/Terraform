# Static Variable Definitions

variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "client_certificate_password" {
  description = "SPN Client Certificate Password"
  type        = string
  sensitive   = true
  default     = ""
}

variable "client_certificate_path" {
  description = "SPN Client Certificate Path"
  type        = string
  sensitive   = true
  default     = ""
}

variable "environment_tag" {
  description = "{Dev,Test,Prod} Environement Tag"
  type        = string
}

variable "environment" {
  description = "Environment Type"
  type        = map(string)
  default = {
    "Dev"  = "d"
    "Test" = "t"
    "Prod" = "p"
  }
}

variable "country_tag" {
  description = "{us,eu} Country Tag for resource naming"
  default     = "us"
  type        = string
}

variable "project_tag" {
  description = "Project Tag"
  type        = string
}

variable "ad" {
  description = "Active Directory"
  default     = "n/a"
  type        = string
}
variable "app_name" {
  description = "Application Name"
  default     = "n/a"
  type        = string
}
variable "confidentiality" {
  description = "Confidentiality"
  default     = "n/a"
  type        = string
}
variable "cost_centre" {
  description = "Cost Centre"
  default     = "n/a"
  type        = string
}
variable "ops_team" {
  description = "Operations Team"
  default     = "Azure Engineering"
  type        = string
}
variable "project_code" {
  description = "Project Code"
  default     = "n/a"
  type        = string
}
variable "region" {
  description = "Azure Region"
  default     = "eastus2"
  type        = string
}
variable "service_hours" {
  description = "Application Service Hours"
  default     = "n/a"
  type        = string
}
variable "service_level" {
  description = "Application Service Level"
  default     = "n/a"
  type        = string
}

variable "vnet_subnet" {
  description = "VNET Subnet CIDR"
  type        = string
}

variable "snet_subnets" {
  description = "SNET Subnet CIDRs"
  type        = list(string)
}

variable "vnet_change" {
  description = "Change Record to cover VNET Peering"
  type        = string
  default     = ""
}

variable "iam_rbac_member_id" {
  description = "Entra ID User Object ID"
  type        = set(string)
}

variable "iam_rbac_role" {
  description = "RBAC role to be assigned to IAM group"
  type        = string
}

variable "group_rbac_change_record" {
  description = "CHG Record Number for Group"
  type        = string
}

variable "iam_rbac_group_owner" {
  description = "Owner of the group"
  type        = string
}

variable "http_hostname" {
  description = "Hostname/Domain of the Application"
  default     = ""
  type        = string
}

variable "plan_sku_name" {
  description = "App Service Plan SKU Name"
  type        = string
}

variable "os_plan_type" {
  description = "App Service Plan OS Type"
  type        = string
}

variable "sql_admin" {
  description = "SQL DB Admin Entra Username"
  type        = string
}

variable "sql_admin_object_id" {
  description = "SQL DB Admin Entra Object ID"
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
  }
}

variable "nsg_map_appservice" {
  type = map(object({
    name                    = string
    priority                = string
    direction               = string
    access                  = string
    protocol                = string
    destination_port_range  = string
    source_address_prefixes = list(string)
  }))
  description = "Map of NSG Rules"
  default = {
    4000 = {
      name                    = "DenyInbound"
      priority                = "4000"
      direction               = "Inbound"
      access                  = "Deny"
      protocol                = "*"
      destination_port_range  = "*"
      source_address_prefixes = ["10.0.0.0/8", "192.168.0.0/16", "172.16.0.0/12"]
    }
  }
}

variable "nsg_map" {
  type = map(object({
    name                    = string
    priority                = string
    direction               = string
    access                  = string
    protocol                = string
    destination_port_range  = string
    source_address_prefixes = list(string)
  }))
  description = "Map of NSG Rules"
  default = {
    4000 = {
      name                    = "DenyInbound"
      priority                = "4000"
      direction               = "Inbound"
      access                  = "Deny"
      protocol                = "*"
      destination_port_range  = "*"
      source_address_prefixes = ["10.0.0.0/8", "192.168.0.0/16", "172.16.0.0/12"]
    }
  }
}

variable "nsg_map_pe" {
  type = map(object({
    name                    = string
    priority                = string
    direction               = string
    access                  = string
    protocol                = string
    destination_port_range  = string
    source_address_prefixes = list(string)
  }))
  description = "Map of NSG Rules"
  default = {
    4000 = {
      name                    = "DenyInbound"
      priority                = "4000"
      direction               = "Inbound"
      access                  = "Deny"
      protocol                = "*"
      destination_port_range  = "*"
      source_address_prefixes = ["10.0.0.0/8", "192.168.0.0/16", "172.16.0.0/12"]
    }
  }
}

variable "nsg_map_sql" {
  type = map(object({
    name                    = string
    priority                = string
    direction               = string
    access                  = string
    protocol                = string
    destination_port_range  = string
    source_address_prefixes = list(string)
  }))
  description = "Map of NSG Rules"
  default = {
    4000 = {
      name                    = "DenyInbound"
      priority                = "4000"
      direction               = "Inbound"
      access                  = "Deny"
      protocol                = "*"
      destination_port_range  = "*"
      source_address_prefixes = ["10.0.0.0/8", "192.168.0.0/16", "172.16.0.0/12"]
    }
  }
}

variable "nsg_map_appgw" {
  type = map(object({
    name                    = string
    priority                = string
    direction               = string
    access                  = string
    protocol                = string
    destination_port_range  = string
    source_address_prefixes = list(string)
  }))
  description = "Map of NSG Rules"
  default = {
    4000 = {
      name                    = "DenyInbound"
      priority                = "4000"
      direction               = "Inbound"
      access                  = "Deny"
      protocol                = "*"
      destination_port_range  = "*"
      source_address_prefixes = ["10.0.0.0/8", "192.168.0.0/16", "172.16.0.0/12"]
    }
  }
}
