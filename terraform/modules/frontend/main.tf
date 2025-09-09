resource "azurerm_resource_group" "res-frontend-rg" {
  location = var.location
  name     = var.resource_group_name
}

resource "azurerm_cdn_frontdoor_profile" "res-cdnfrontdoor-profile" {
  name                     = var.fd_profile_name
  resource_group_name      = var.resource_group_name
  response_timeout_seconds = 60
  sku_name                 = "Standard_AzureFrontDoor"
  depends_on = [
    azurerm_resource_group.res-frontend-rg
  ]
}

resource "random_id" "res-ran-id" {
  byte_length = 4
}

resource "azurerm_cdn_frontdoor_endpoint" "res-cdn-frontdoor-end" {
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.res-cdnfrontdoor-profile.id
  enabled                  = true
  name                     = var.fd_endpoint_name
}

resource "azurerm_cdn_frontdoor_origin_group" "res-fd-origin-group" {
  cdn_frontdoor_profile_id                                  = azurerm_cdn_frontdoor_profile.res-cdnfrontdoor-profile.id
  name                                                      = "default-origin-group-723f3aac001"
  restore_traffic_time_to_healed_or_new_endpoint_in_minutes = 0
  session_affinity_enabled                                  = false
  load_balancing {
    sample_size                        = 4
    successful_samples_required        = 3
    additional_latency_in_milliseconds = 50
  }
}
resource "azurerm_cdn_frontdoor_origin" "res-cdn-fd-origin" {
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.res-fd-origin-group.id
  certificate_name_check_enabled = true
  host_name                      = "${azurerm_storage_account.res-storage-account.name}.z20.web.core.windows.net"
  name                           = "default-origin"
  origin_host_header             = "${azurerm_storage_account.res-storage-account.name}.z20.web.core.windows.net"
  weight                         = 1000
  http_port                      = 80
  https_port                     = 443
  priority                       = 1
  enabled                        = true
}
resource "azurerm_storage_account" "res-storage-account" {
  access_tier                       = "Hot"
  account_kind                      = "StorageV2"
  account_replication_type          = "LRS"
  account_tier                      = "Standard"
  allow_nested_items_to_be_public   = true
  cross_tenant_replication_enabled  = false
  default_to_oauth_authentication   = false
  dns_endpoint_type                 = "Standard"
  https_traffic_only_enabled        = true
  infrastructure_encryption_enabled = false
  is_hns_enabled                    = false
  nfsv3_enabled                     = false
  large_file_share_enabled          = true
  local_user_enabled                = true
  location                          = var.location
  min_tls_version                   = "TLS1_2"
  queue_encryption_key_type         = "Service"
  shared_access_key_enabled         = true
  table_encryption_key_type         = "Service"
  public_network_access_enabled     = true
  sftp_enabled                      = false
  name                              = "frontendstor${random_id.res-ran-id.hex}"
  resource_group_name               = var.resource_group_name

  blob_properties {
    change_feed_enabled      = false
    last_access_time_enabled = false
    versioning_enabled       = false
    container_delete_retention_policy {
      days = 7
    }
    delete_retention_policy {
      days                     = 7
      permanent_delete_enabled = false
    }
  }

  network_rules {
    bypass         = ["AzureServices"]
    default_action = "Allow"
    ip_rules       = ["67.48.4.44", "68.206.248.42", "184.92.107.198"]
  }
  share_properties {
    retention_policy {
      days = 7
    }
  }
  depends_on = [
    azurerm_resource_group.res-frontend-rg
  ]
}
resource "time_sleep" "res-app-service-sleep" {
  create_duration = "300s"
  depends_on = [
    azurerm_storage_account.res-storage-account
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
resource "azurerm_storage_account_static_website" "res-stor-acc-stat-site" {
  storage_account_id = azurerm_storage_account.res-storage-account.id
  error_404_document = "index.html"
  index_document     = "index.html"
}
