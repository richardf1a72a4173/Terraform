# Terraform config and version constraints

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.29.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "2.4.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.5.0"
    }
  }

  backend "azurerm" {
  }

  required_version = ">= 1.9.5"
}
