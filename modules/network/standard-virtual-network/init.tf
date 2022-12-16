terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.24.0"
    }
  }
  experiments = [module_variable_optional_attrs]
}

provider "azurerm" {
  features {}
  alias           = "hub"
  subscription_id = local.hub_virtual_network_subscription
}

provider "azurerm" {
  features {}
  alias           = "vwan"
  subscription_id = "8d21bc38-6be5-4983-baa2-e859067b5faf"
}