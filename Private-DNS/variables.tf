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

variable "country_tag2" {
  description = "{us,eu} Country Tag for resource naming"
  default     = "eu"
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
variable "region2" {
  description = "Azure Region"
  default     = "westeurope"
}
variable "service_hours" {
  description = "Application Service Hours"
  default     = "n/a"
}
variable "service_level" {
  description = "Application Service Level"
  default     = "n/a"
}
variable "region2-vnet" {
  description = "Second VNET Subnet"
}
variable "region2-snets" {
  description = "Second Region Subnets"
}
variable "nsg_map_eu_ie" {
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
variable "nsg_map_eu_oe" {
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