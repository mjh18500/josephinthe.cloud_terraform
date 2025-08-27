# APIM Gateway URL (with base API path)
output "apim_api_url" {
  description = "The APIM endpoint for the http_trigger API"
  value       = "https://${azurerm_api_management.res-api-management.gateway_url}"
}

# Function App default URL
output "function_app_url" {
  description = "The Function App default root URL"
  value       = "https://${azurerm_linux_function_app.res-lin-func-app.default_hostname}"
}
