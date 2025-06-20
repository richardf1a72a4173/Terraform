variable "from_vnet_peer_name" {
  type = string
  description = "Local vNet Peer Name"
}

variable "from_vnet_name" {
  type = string
  description = "Local vNet Name"
}

variable "from_remote_vnet_id" {
  type = string
  description = "Remote vNet ID"
}

variable "rg_name" {
  type = string
  description = "Local Resource Group Name"
}
variable "remote_rg_name" {
  type = string
  description = "Remote Resource Group Name"
}

variable "to_vnet_name" {
  type = string
  description = "Remote vNet Name"
}

variable "to_vnet_peer_name" {
  type = string
  description = "Remote vNet Peer Name"
}

variable "to_remote_vnet_id" {
  type = string
  description = "Remote vNet ID"
}