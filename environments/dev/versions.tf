terraform {
  required_version = ">= 1.0.0"
  backend "azurerm" {
    # Replace with your storage account details for state locking
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "terraformstateoag"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
