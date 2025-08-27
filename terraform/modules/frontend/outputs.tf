output "frontdoor_endpoint_url" {
  description = "The full URL of the Front Door endpoint"
  value       = "https://${azurerm_cdn_frontdoor_endpoint.res-cdn-frontdoor-end.host_name}"
}