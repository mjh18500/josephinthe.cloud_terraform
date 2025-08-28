output "frontdoor_endpoint_url" {
  description = "The full URL of the Front Door endpoint"
  value       = "https://${azurerm_cdn_frontdoor_endpoint.res-cdn-frontdoor-end.host_name}"
}

# Outputs for prod/main.tf

output "fd_profile_id" {
  value = azurerm_cdn_frontdoor_profile.res-cdnfrontdoor-profile.id
}

output "fd_endpoint_id" {
  value = azurerm_cdn_frontdoor_endpoint.res-cdn-frontdoor-end.id
}

output "fd_origin_group_id" {
  value = azurerm_cdn_frontdoor_origin_group.res-fd-origin-group.id
}

output "fd_origin_id" {
  value = azurerm_cdn_frontdoor_origin.res-cdn-fd-origin.id
}