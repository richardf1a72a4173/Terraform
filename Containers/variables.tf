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

variable "client_secret" {
  type      = string
  sensitive = true
}