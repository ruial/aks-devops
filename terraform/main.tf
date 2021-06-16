terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
    azuredevops = {
      source = "microsoft/azuredevops"
      version = "=0.1.5"
    }
  }
}

provider "azurerm" {
  features {}
}
