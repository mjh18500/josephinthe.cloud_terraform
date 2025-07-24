resource "azurerm_resource_group" "res-0" {
  location = "eastus2"
  name     = "Dev_ResourceGroup1"
}
resource "azurerm_cdn_endpoint_custom_domain" "res-1" {
  cdn_endpoint_id = azurerm_cdn_endpoint.res-17.id
  host_name       = "www.josephinthe.cloud"
  name            = "www-josephinthe-cloud"
  cdn_managed_https {
    certificate_type = "Dedicated"
    protocol_type    = "ServerNameIndication"
  }
}
resource "azurerm_cdn_frontdoor_profile" "res-3" {
  name                     = "dev00fdProfile"
  resource_group_name      = "Dev_ResourceGroup1"
  response_timeout_seconds = 60
  sku_name                 = "Standard_AzureFrontDoor"
  depends_on = [
    azurerm_resource_group.res-0
  ]
}
resource "azurerm_cdn_frontdoor_route" "res-5" {
  cdn_frontdoor_custom_domain_ids = [azurerm_cdn_frontdoor_custom_domain.res-6.id]
  cdn_frontdoor_endpoint_id       = "/subscriptions/ebeec867-0bac-448a-b3ba-197e572e0b4c/resourceGroups/Dev_ResourceGroup1/providers/Microsoft.Cdn/profiles/dev00fdProfile/afdEndpoints/dev00fdEndpoint"
  cdn_frontdoor_origin_group_id   = azurerm_cdn_frontdoor_origin_group.res-7.id
  name                            = "default-route"
  patterns_to_match               = ["/*"]
  supported_protocols             = ["Http", "Https"]
}
resource "azurerm_cdn_frontdoor_custom_domain" "res-6" {
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.res-3.id
  host_name                = "josephinthe.cloud"
  name                     = "josephinthe-cloud-4945"
  tls {
  }
}
resource "azurerm_cdn_frontdoor_origin_group" "res-7" {
  cdn_frontdoor_profile_id                                  = azurerm_cdn_frontdoor_profile.res-3.id
  name                                                      = "default-origin-group-723f3aac"
  restore_traffic_time_to_healed_or_new_endpoint_in_minutes = 0
  session_affinity_enabled                                  = false
  load_balancing {
  }
}
resource "azurerm_cdn_frontdoor_origin" "res-8" {
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.res-7.id
  certificate_name_check_enabled = true
  host_name                      = "dev00storageaccount.z20.web.core.windows.net"
  name                           = "default-origin"
  origin_host_header             = "dev00storageaccount.z20.web.core.windows.net"
  weight                         = 1000
}
resource "azurerm_storage_account" "res-10" {
  account_replication_type = "LRS"
  account_tier             = "Standard"
  location                 = "eastus2"
  name                     = "dev00storageaccount"
  resource_group_name      = "Dev_ResourceGroup1"
  depends_on = [
    azurerm_resource_group.res-0
  ]
}
resource "azurerm_storage_container" "res-12" {
  container_access_type = "container"
  name                  = "$web"
  storage_account_id    = "/subscriptions/ebeec867-0bac-448a-b3ba-197e572e0b4c/resourceGroups/Dev_ResourceGroup1/providers/Microsoft.Storage/storageAccounts/dev00storageaccount"
  depends_on = [
    # One of azurerm_storage_account.res-10,azurerm_storage_account_queue_properties.res-14 (can't auto-resolve as their ids are identical)
  ]
}
resource "azurerm_storage_account_queue_properties" "res-14" {
  storage_account_id = azurerm_storage_account.res-10.id
  hour_metrics {
    version = "1.0"
  }
  logging {
    delete  = false
    read    = false
    version = "1.0"
    write   = false
  }
  minute_metrics {
    version = "1.0"
  }
}
resource "azurerm_cdn_profile" "res-16" {
  location            = "global"
  name                = "dev00CDNProfile"
  resource_group_name = "Dev_ResourceGroup1"
  sku                 = "Standard_Microsoft"
  depends_on = [
    azurerm_resource_group.res-0
  ]
}
resource "azurerm_cdn_endpoint" "res-17" {
  content_types_to_compress     = ["application/eot", "application/font", "application/font-sfnt", "application/javascript", "application/json", "application/opentype", "application/otf", "application/pkcs7-mime", "application/truetype", "application/ttf", "application/vnd.ms-fontobject", "application/x-font-opentype", "application/x-font-truetype", "application/x-font-ttf", "application/x-httpd-cgi", "application/x-javascript", "application/x-mpegurl", "application/x-opentype", "application/x-otf", "application/x-perl", "application/x-ttf", "application/xhtml+xml", "application/xml", "application/xml+rss", "font/eot", "font/opentype", "font/otf", "font/ttf", "image/svg+xml", "text/css", "text/csv", "text/html", "text/javascript", "text/js", "text/plain", "text/richtext", "text/tab-separated-values", "text/x-component", "text/x-java-source", "text/x-script", "text/xml"]
  is_compression_enabled        = true
  location                      = "global"
  name                          = "dev00CDNendpoint"
  origin_host_header            = "dev00storageaccount.z20.web.core.windows.net"
  profile_name                  = "dev00CDNProfile"
  querystring_caching_behaviour = "UseQueryString"
  resource_group_name           = "Dev_ResourceGroup1"
  delivery_rule {
    name  = "Redirect"
    order = 1
    request_uri_condition {
      match_values = ["http://josephinthe.cloud", "https://josephinthe.cloud", "josephinthe.cloud"]
      operator     = "BeginsWith"
      transforms   = ["Lowercase"]
    }
    url_redirect_action {
      hostname      = "google.com"
      protocol      = "Https"
      redirect_type = "PermanentRedirect"
    }
  }
  origin {
    host_name = "dev00storageaccount.z20.web.core.windows.net"
    name      = "default-origin-6c1b74aa"
  }
  depends_on = [
    azurerm_cdn_profile.res-16
  ]
}
