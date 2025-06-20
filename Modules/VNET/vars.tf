variable "vnet_name" {
  type        = string
  description = "Name of vNet"
  default     = "vnet-vnet-001"
}

variable "rg_name" {
  type        = string
  description = "Resource Group Name"
}

variable "location" {
  type        = string
  description = "Resource Location"
}

variable "vnet_address" {
  type        = string
  description = "vNet Address Space"
}

variable "snet_name" {
  type        = string
  description = "SNet Name"
  default     = "snet-vnet-001"
}

variable "snet_address" {
  type        = string
  description = "Subnet Address Space"
}

variable "nat_gateway" {
  type        = bool
  description = "Provision a NAT gateway for outbound access"
  default     = false
}

variable "resource_template" {
  description = "Resource Name Template"
  default     = "-vnet-"
}
