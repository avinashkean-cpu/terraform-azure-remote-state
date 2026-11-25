# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=5.0.0"
    }
  }
  
# Backeng Block for remote state access

  backend "azurerm" {
  use_cli              = true
  use_azuread_auth     = true
  storage_account_name = "storageaccount00965"
  container_name       = "tfstate"
  key                  = "terraform.tfstate"
}
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}