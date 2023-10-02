terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.74.0"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = "true"
  features {}
}

resource "azurerm_resource_group" "BKY-RG" {
  name     = "BKY-RG_Project"
  location = "West US"
  tags = {
    environment = "Dev"
  }
}

