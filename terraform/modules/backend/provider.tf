provider "azurerm" {
  features {
  }
  subscription_id                 = "ebeec867-0bac-448a-b3ba-197e572e0b4c"
  environment                     = "public"
  use_msi                         = false
  use_cli                         = true
  use_oidc                        = false
  resource_provider_registrations = "none"
}
