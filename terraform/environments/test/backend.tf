terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraformstate"
    storage_account_name = "josephcloudtfstateacc001"
    container_name       = "statecontainer"
    key                  = "test.terraform.tfstate"
  }
}



