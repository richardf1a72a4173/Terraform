# Static Variable Definitions

variable "subscription_id" {
  description = "Azure Subscription ID"
}

variable "environment_tag" {
  description = "{Dev,Test,Prod} Environement Tag"
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
}

variable "project_tag" {
  description = "Project Tag"
}

variable "ad" {
  description = "Active Directory"
  default     = "n/a"
}
variable "app_name" {
  description = "Application Name"
  default     = "n/a"
}
variable "confidentiality" {
  description = "Confidentiality"
  default     = "n/a"
}
variable "cost_centre" {
  description = "Cost Centre"
  default     = "n/a"
}
variable "ops_team" {
  description = "Operations Team"
  default     = "Azure Engineering"
}
variable "project_code" {
  description = "Project Code"
  default     = "n/a"
}
variable "region" {
  description = "Azure Region"
  default     = "eastus2"
}
variable "service_hours" {
  description = "Application Service Hours"
  default     = "n/a"
}
variable "service_level" {
  description = "Application Service Level"
  default     = "n/a"
}

variable "vnet_subnet" {
  description = "VNET Subnet CIDR"
}

variable "snet_subnets" {
  description = "SNET Subnet CIDRs"
}

# variable "iam_rbac_member" {
#   description = "Entra ID User for initial assignment to group"
# }

variable "iam_rbac_member_id" {
  description = "Entra ID User Object ID"
}

variable "iam_rbac_role" {
  description = "RBAC role to be assigned to IAM group"
}

variable "group_rbac_change_record" {
  description = "CHG Record Number for Group"
}

variable "iam_rbac_group_owner" {
  description = "Owner of the group"
}

variable "mysql_admin" {
  description = "MySQL DB Admin Username"
}

variable "mysql_password" {
  description = "MySQL DB Admin Password"
}

variable "http_hostname" {
  description = "Hostname/Domain of the Application"
  default     = ""
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

variable "dns_zones" {
  description = "The Private DNS Zones to be linked"
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
  }
}
