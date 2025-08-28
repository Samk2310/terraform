terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "> 4.3.34"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 3.3.0"
    }
  }
}

provider "azurerm" {
  resource_provider_registrations = "none"

  features {

  }
}

provider "azuread" {

}
