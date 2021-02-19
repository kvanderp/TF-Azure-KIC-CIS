# Main

terraform {
  required_version = "~> 0.12"
  required_providers {
      azurerm = "~> 2.47.0"
  }
}

# Azure Provider
provider "azurerm" {
  features {}
  subscription_id = var.sp_subscription_id
  client_id = var.sp_client_id
  client_secret = var.sp_client_secret
  tenant_id = var.sp_tenant_id
}

# Create a Resource Group
resource "azurerm_resource_group" "main" {
    name     = "${var.prefix}_rg"
    location = var.location

    tags = {
        purpose     = var.purpose
        environment = var.environment
        owner       = var.owner
        group       = var.group
        costcenter  = var.costcenter
        application = var.application
    }
}