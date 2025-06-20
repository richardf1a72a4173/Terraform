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

variable "iam_rbac_member" {
  description = "Entra ID User for initial assignment to group"
}

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

variable "rbac_group_object_id" {
  description = "Object ID of Existing RBAC Group"
}
