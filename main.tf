terraform{
 backend "azurerm" {
    storage_account_name = "storeaccghgy"
    container_name       = "terraform-state-dev"
    key                  = "jenkins-terraform.tfstate"
    use_azuread_auth     = true
    use_oidc             = true
    subscription_id      = "9919455d-a384-407d-849e-190bad4af9d7"
    tenant_id            = "550d7d5c-247a-472e-af33-9915c948872b"
    resource_group_name  = "azure-terraform-git"
  }
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-tf-demo"
  location = "East US"
}

resource "azurerm_storage_account" "sa" {
  name                     = "satfdemo${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

output "storage_account_name" {
  value = azurerm_storage_account.sa.name
}

