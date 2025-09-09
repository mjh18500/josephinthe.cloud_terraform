terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraformstate"
    storage_account_name = ""
    container_name       = "statecontainer"
    key                  = "test.terraform.tfstate"
    use_oidc             = true
    use_azuread_auth     = true
  }
}




