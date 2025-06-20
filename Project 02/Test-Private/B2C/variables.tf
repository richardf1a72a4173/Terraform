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

variable "b2c_users" {
  description = "Users to create in B2C tenant"
  type = map(object({
    upn          = string
    display_name = string
    element_mail = string
  }))
}
