# Terraform config and version constraints

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  backend "azurerm" {
  }

  required_version = ">= 1.9.5"
}