resource "azurerm_resource_group" "res-frontend-rg" {
  location = var.location
  name     = var.resource_group_name
}

//not using custom domain for this test
/*
resource "azurerm_cdn_endpoint_custom_domain" "res-custom-domain" {
  cdn_endpoint_id = azurerm_cdn_endpoint.res-cdn-endpoint.id
  host_name       = "www.josephinthe.cloud"
  name            = "www-josephinthe-cloud"
  cdn_managed_https {
    certificate_type = "Dedicated"
    protocol_type    = "ServerNameIndication"
  }
}
*/

resource "azurerm_cdn_frontdoor_profile" "res-cdnfrontdoor-profile" {
  name                     = var.fd_profile_name
  resource_group_name      = var.resource_group_name
  response_timeout_seconds = 60
  sku_name                 = "Standard_AzureFrontDoor"
  depends_on = [
    azurerm_resource_group.res-frontend-rg
  ]
}
resource "azurerm_cdn_frontdoor_route" "res-cdn-frontdoor-route" {
  //not using custom domain
  #cdn_frontdoor_custom_domain_ids = [azurerm_cdn_frontdoor_custom_domain.res-fd-custom-domain.id]
  cdn_frontdoor_endpoint_id       = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Cdn/profiles/${var.fd_profile_name}/afdEndpoints/cdnFDendpoint001"
  cdn_frontdoor_origin_group_id   = azurerm_cdn_frontdoor_origin_group.res-fd-origin-group.id
  name                            = "default-route"
  patterns_to_match               = ["/*"]
  supported_protocols             = ["Http", "Https"]
}

//not using custom domain
/*
resource "azurerm_cdn_frontdoor_custom_domain" "res-fd-custom-domain" {
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.res-cdnfrontdoor-profile.id
  host_name                = "josephinthe.cloud"
  name                     = "josephinthe-cloud-4945"
  tls {
  }
}
*/

resource "azurerm_cdn_frontdoor_origin_group" "res-fd-origin-group" {
  cdn_frontdoor_profile_id                                  = azurerm_cdn_frontdoor_profile.res-cdnfrontdoor-profile.id
  name                                                      = "default-origin-group-723f3aac001"
  restore_traffic_time_to_healed_or_new_endpoint_in_minutes = 0
  session_affinity_enabled                                  = false
  load_balancing {
  }
}
resource "azurerm_cdn_frontdoor_origin" "res-cdn-fd-origin" {
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.res-fd-origin-group.id
  certificate_name_check_enabled = true
  host_name                      = "${var.storage_account_name}.z20.web.core.windows.net"
  name                           = "default-origin"
  origin_host_header             = "${var.storage_account_name}.z20.web.core.windows.net"
  weight                         = 1000
}
resource "azurerm_storage_account" "res-storage-account" {
  account_replication_type = "LRS"
  account_tier             = "Standard"
  location                 = var.location
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  depends_on = [
    azurerm_resource_group.res-frontend-rg
  ]
}
resource "azurerm_storage_container" "res-storage-container" {
  container_access_type = "container"
  name                  = "$web"
  storage_account_id    = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Storage/storageAccounts/${var.storage_account_name}"
  depends_on = [
    # One of azurerm_storage_account.res-storage-account,azurerm_storage_account_queue_properties.res-sa-queue-properties (can't auto-resolve as their ids are identical)
  ]
}
resource "azurerm_storage_account_queue_properties" "res-sa-queue-properties" {
  storage_account_id = azurerm_storage_account.res-storage-account.id
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
resource "azurerm_cdn_profile" "res-cdn-profile" {
  location            = "global"
  name                = var.cdn_profile_name
  resource_group_name = var.resource_group_name
  sku                 = "Standard_Microsoft"
  depends_on = [
    azurerm_resource_group.res-frontend-rg
  ]
}
resource "azurerm_cdn_endpoint" "res-cdn-endpoint" {
  content_types_to_compress     = ["application/eot", "application/font", "application/font-sfnt", "application/javascript", "application/json", "application/opentype", "application/otf", "application/pkcs7-mime", "application/truetype", "application/ttf", "application/vnd.ms-fontobject", "application/x-font-opentype", "application/x-font-truetype", "application/x-font-ttf", "application/x-httpd-cgi", "application/x-javascript", "application/x-mpegurl", "application/x-opentype", "application/x-otf", "application/x-perl", "application/x-ttf", "application/xhtml+xml", "application/xml", "application/xml+rss", "font/eot", "font/opentype", "font/otf", "font/ttf", "image/svg+xml", "text/css", "text/csv", "text/html", "text/javascript", "text/js", "text/plain", "text/richtext", "text/tab-separated-values", "text/x-component", "text/x-java-source", "text/x-script", "text/xml"]
  is_compression_enabled        = true
  location                      = "global"
  name                          = var.cdn_endpoint_name
  origin_host_header            = "${var.storage_account_name}.z20.web.core.windows.net"
  profile_name                  = var.cdn_profile_name
  querystring_caching_behaviour = "UseQueryString"
  resource_group_name           = var.resource_group_name
  origin {
    host_name = "${var.storage_account_name}.z20.web.core.windows.net"
    name      = "default-origin-6c1b74aa001"
  }
  depends_on = [
    azurerm_cdn_profile.res-cdn-profile
  ]
}
