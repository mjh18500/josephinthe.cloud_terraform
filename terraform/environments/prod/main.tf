provider "azurerm" {
  features {}
}



module "backend" {
  source              = "../../modules/backend"
  resource_group_name = "Backend_${var.resource_group_name}_${var.env_name}"
  location            = var.location
  api_publisher_name  = "Joseph Hernandez"
  api_publisher_email = "joseph@josephinthe.cloud"
  api_title           = "functionAPI"
  cosmosdb_name       = "backendcosmosdb010"
  user_object_id      = var.user_object_id
  subscription_id     = var.subscription_id
  env_name            = var.env_name
}

module "frontend" {
  source              = "../../modules/frontend"
  location            = var.location
  resource_group_name = "Frontend_${var.resource_group_name}_${var.env_name}"
  fd_profile_name     = "Frontendfdprofile"
  fd_endpoint_name    = "prod-jcloud"
}

# Extra prod-only resources
resource "azurerm_cdn_frontdoor_custom_domain" "res-fd-custom-domain" {
  cdn_frontdoor_profile_id = module.frontend.fd_profile_id
  host_name                = "josephinthe.cloud"
  name                     = "josephinthe-cloud-4945"

  tls {}
}

resource "azurerm_cdn_frontdoor_route" "res-cdn-frontdoor-route" {
  cdn_frontdoor_custom_domain_ids = [azurerm_cdn_frontdoor_custom_domain.res-fd-custom-domain.id]
  cdn_frontdoor_endpoint_id       = module.frontend.fd_endpoint_id
  cdn_frontdoor_origin_group_id   = module.frontend.fd_origin_group_id
  cdn_frontdoor_origin_ids        = [module.frontend.fd_origin_id]

  name                   = "default-route"
  patterns_to_match      = ["/*"]
  enabled                = true
  supported_protocols    = ["Http", "Https"]
  forwarding_protocol    = "MatchRequest"
  https_redirect_enabled = true
  link_to_default_domain = true
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