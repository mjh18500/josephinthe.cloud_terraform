provider "azurerm" {
  features {}
  subscription_id                 = "ebeec867-0bac-448a-b3ba-197e572e0b4c"
  environment                     = "public"
  use_msi                         = false
  use_cli                         = true
  use_oidc                        = false
  resource_provider_registrations = "none"
}

//function_app_name must be unique
//function app name. Valid characters are a-z (case insensitive), 0-9, and -.
//user_object_id for role assigments
//location_short used for naming
//storage_account_name must be unique. 
//Storage account name must be between 3 and 24 characters in length and use numbers and lower-case letters only.

module "backend" {
  source               = "../../modules/backend"
  resource_group_name  = "Backend_API_${var.resource_group_name}"
  location             = var.location
  location_short       = "EUS2" 
  api_publisher_name   = "Joseph Hernandez"
  api_publisher_email  = "joseph@josephinthe.cloud"
  function_app_name    = "Backendjosephinthecloud-${var.env_name}"
  cosmosdb_name        = "backendcosmosdb002"
  user_object_id       = "e9bcdf18-cd9d-4805-ad21-594dad348e61"  
  storage_account_name = "back${var.env_name}storacc03" 
}

//storage_account_name must be unique

module "frontend" {
  source               = "../../modules/frontend"
  location             = var.location
  storage_account_name = "front${var.env_name}storacc02"
  resource_group_name  = "Frontend_${var.resource_group_name}"
  fd_profile_name      = "Frontend_fdprofile"
  subscription_id      = "ebeec867-0bac-448a-b3ba-197e572e0b4c"
  cdn_profile_name     = "Frontend_cdnProfile"
  cdn_endpoint_name    = "Frontend_cdnendpoint"    
}
