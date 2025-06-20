# Terraform config and version constraints

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.29.0"
    }
    # acme = {
    #   source  = "vancluever/acme"
    #   version = "2.28.0"
    # }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.13.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.5.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.4.0"
    }
  }

  backend "azurerm" {
  }

  required_version = ">= 1.9.5"
}
