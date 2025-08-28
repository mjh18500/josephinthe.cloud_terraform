provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}


//function_app_name must be unique
//function app name. Valid characters are a-z (case insensitive), 0-9, and -.
//user_object_id for role assigments
//storage_account_name must be unique. 
//Storage account name must be between 3 and 24 characters in length and use numbers and lower-case letters only.


module "backend" {
  source              = "../../modules/backend"
  resource_group_name = "Backend_${var.resource_group_name}_${var.env_name}"
  location            = var.location
  api_publisher_name  = "Joseph Hernandez"
  api_publisher_email = "joseph@josephinthe.cloud"
  api_title           = "functionAPI"
  cosmosdb_name       = "backendcosmosdb007"
  user_object_id      = var.user_object_id
  subscription_id     = var.subscription_id
  env_name            = var.env_name
}

module "frontend" {
  source              = "../../modules/frontend"
  location            = var.location
  resource_group_name = "Frontend_${var.resource_group_name}_${var.env_name}"
  fd_profile_name     = "Frontendfdprofile"
  fd_endpoint_name    = "test-${var.pr_number}"
}

resource "azurerm_cdn_frontdoor_route" "res-cdn-frontdoor-route" {
  cdn_frontdoor_endpoint_id     = module.frontend.fd_endpoint_id
  cdn_frontdoor_origin_group_id = module.frontend.fd_origin_group_id
  cdn_frontdoor_origin_ids      = [module.frontend.fd_origin_id]

  name                = "default-route"
  patterns_to_match   = ["/*"]
  enabled             = true
  supported_protocols = ["Http", "Https"]
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

output "cosmosdb_url" {
  value = module.backend.cosmosdb_url
}