variable "group_name" {
  description = "Name of Group - AZ-AZURE-{xxx}"
  type        = string
}

variable "group_owner" {
  description = "Owner Object ID"
  type        = string
}

variable "group_members" {
  description = "List of Group Member IDs"
  type        = set(string)
}

variable "change_number" {
  description = "Change Record for Group"
  type        = string
}

variable "group_description" {
  description = "Description tag for Group"
  type        = string
}

# variable "pim_upn" {
#   description = "Account of PIM User"
#   default     = "user@example.tld"
# }
