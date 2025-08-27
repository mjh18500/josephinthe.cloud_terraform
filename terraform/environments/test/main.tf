provider "azurerm" {
  features {}
}


//function_app_name must be unique
//function app name. Valid characters are a-z (case insensitive), 0-9, and -.
//user_object_id for role assigments
//location_short used for naming
//storage_account_name must be unique. 
//Storage account name must be between 3 and 24 characters in length and use numbers and lower-case letters only.


module "backend" {
  source               = "../../modules/backend"
  resource_group_name  = "Backend_${var.resource_group_name}_${var.env_name}"
  location             = var.location
  location_short       = "EUS2"
  api_publisher_name   = "Joseph Hernandez"
  api_first_name       = "Joseph"
  api_last_name        = "Hernandez"
  api_publisher_email  = "joseph@josephinthe.cloud"
  api_title            = "functionAPI"
  cosmosdb_name        = "backendcosmosdb007"
  user_object_id       = "e9bcdf18-cd9d-4805-ad21-594dad348e61"
  service_principal_id = "f318ff35-9355-46b0-9eab-28dcc9a5c7cd"
  subscription_id      = var.subscription_id
  env_name             = var.env_name
}

//storage_account_name must be unique

module "frontend" {
  source              = "../../modules/frontend"
  location            = var.location
  resource_group_name = "Frontend_${var.resource_group_name}_${var.env_name}"
  fd_profile_name     = "Frontendfdprofile"
  subscription_id     = var.subscription_id
  //cdn_profile_name     = "josephcloudcdnProfile"  
  fd_endpoint_name    = "test-${var.pr_number}"
}

output "frontdoor_endpoint_url" {
  value = module.frontend.frontdoor_endpoint_url
}

output "apim_api_url" {
  value = module.backend.apim_api_url
}

output "function_app_url" {
  value = module.backend.function_app_url
}