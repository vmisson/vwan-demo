terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    azapi = {
      source = "azure/azapi"
    }
  }
  # backend "azurerm" {
  #   #subscription_id      = ""
  #   resource_group_name  = "admin-tools-rg"
  #   storage_account_name = "tfstatevmi"
  #   container_name       = "tfstate"
  #   key                  = "demo-vwan.tfstate"
  # }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

provider "azapi" {
}