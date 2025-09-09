resource "random_id" "res-ran-id" {
  byte_length = 4
}
resource "azurerm_resource_group" "res-backend-rg" {
  location = var.location
  name     = var.resource_group_name
}
resource "azurerm_api_management" "res-api-management" {
  client_certificate_enabled    = false
  gateway_disabled              = false
  public_network_access_enabled = true
  virtual_network_type          = "None"
  location                      = var.location
  name                          = "jcloud${var.env_name}-apim-${random_id.res-ran-id.hex}"
  publisher_email               = var.api_publisher_email
  publisher_name                = var.api_publisher_name
  resource_group_name           = azurerm_resource_group.res-backend-rg.name
  sku_name                      = "Consumption_0"

  identity {
    type = "SystemAssigned"
  }

  timeouts {
    create = "90m"
    update = "90m"
    delete = "90m"
  }

  depends_on = [
    azurerm_resource_group.res-backend-rg
  ]
}

locals {
  clean_function_app_name = lower("jcloud-${var.env_name}funcapp-${random_id.res-ran-id.hex}")
  api_base_path           = local.clean_function_app_name
  revision                = 1
  revision_suffix         = format(";rev=%s", local.revision)
}

data "template_file" "api_spec" {
  template = file("${path.module}/api1.yaml.tpl")
  vars = {
    api_title         = var.api_title
    apim_hostname     = replace(azurerm_api_management.res-api-management.gateway_url, "https://", "")
    function_app_name = local.clean_function_app_name
    base_path         = local.api_base_path
    title             = var.api_title
  }
}

resource "azurerm_api_management_api" "res-api-man-api" {
  name                  = "${var.env_name}_API"
  resource_group_name   = azurerm_api_management.res-api-management.resource_group_name
  api_management_name   = azurerm_api_management.res-api-management.name
  revision              = local.revision
  display_name          = var.api_title
  path                  = local.api_base_path
  protocols             = ["https"]
  subscription_required = false

  import {
    content_format = "openapi"
    content_value  = data.template_file.api_spec.rendered
  }
}

resource "azurerm_api_management_api_operation_policy" "res-api-operation-policy1" {
  api_management_name = azurerm_api_management.res-api-management.name
  api_name            = azurerm_api_management_api.res-api-man-api.name
  operation_id        = "http-trigger"
  resource_group_name = azurerm_resource_group.res-backend-rg.name

  xml_content = templatefile("${path.module}/apim-policy.xml.tmpl", {
    function_key = azurerm_api_management_named_value.res-api-management-named-value.value
    backend_id   = azurerm_api_management_backend.res-api-management-backend.name
    base_path    = local.api_base_path
    backend_url  = "https://${azurerm_linux_function_app.res-lin-func-app.name}.azurewebsites.net"
  })
  depends_on = [
    azurerm_api_management_api.res-api-man-api,
    azurerm_api_management_backend.res-api-management-backend
  ]
}

resource "azurerm_api_management_backend" "res-api-management-backend" {
  api_management_name = azurerm_api_management.res-api-management.name
  name                = "apimanbackend07"
  protocol            = "http"
  resource_group_name = azurerm_resource_group.res-backend-rg.name
  url                 = "https://${azurerm_linux_function_app.res-lin-func-app.default_hostname}/api"
  credentials {
    header = {
      "x-functions-key" = data.azurerm_function_app_host_keys.keys.default_function_key
    }
  }
  depends_on = [
    azurerm_api_management.res-api-management, azurerm_resource_group.res-backend-rg, azurerm_linux_function_app.res-lin-func-app
  ]
}

data "azurerm_function_app_host_keys" "keys" {
  name                = azurerm_linux_function_app.res-lin-func-app.name
  resource_group_name = azurerm_linux_function_app.res-lin-func-app.resource_group_name
}

resource "azurerm_api_management_named_value" "res-api-management-named-value" {
  api_management_name = azurerm_api_management.res-api-management.name
  display_name        = "funcapp-nv-key"
  name                = "funcapp-nv-key"
  resource_group_name = azurerm_resource_group.res-backend-rg.name
  value               = data.azurerm_function_app_host_keys.keys.default_function_key
  secret              = true
  tags                = ["key", "function", "auto"]
  depends_on = [
    azurerm_api_management.res-api-management, azurerm_resource_group.res-backend-rg
  ]
}
resource "azurerm_api_management_subscription" "res-api-man-sub3" {
  allow_tracing       = false
  api_id              = trimsuffix(azurerm_api_management_api.res-api-man-api.id, local.revision_suffix)
  api_management_name = azurerm_api_management.res-api-management.name
  display_name        = "public"
  resource_group_name = azurerm_resource_group.res-backend-rg.name
  state               = "active"

  depends_on = [
    azurerm_resource_group.res-backend-rg, azurerm_api_management.res-api-management, azurerm_api_management_api.res-api-man-api
  ]
}

resource "azurerm_cosmosdb_account" "res-cosmosdb-account" {
  access_key_metadata_writes_enabled    = true
  analytical_storage_enabled            = false
  automatic_failover_enabled            = true
  burst_capacity_enabled                = false
  create_mode                           = "Default"
  default_identity_type                 = "FirstPartyIdentity"
  free_tier_enabled                     = false
  is_virtual_network_filter_enabled     = false
  kind                                  = "GlobalDocumentDB"
  local_authentication_disabled         = false
  minimal_tls_version                   = "Tls12"
  multiple_write_locations_enabled      = false
  network_acl_bypass_for_azure_services = false
  offer_type                            = "Standard"
  partition_merge_enabled               = false
  public_network_access_enabled         = true
  location                              = var.location
  name                                  = var.cosmosdb_name
  resource_group_name                   = azurerm_resource_group.res-backend-rg.name
  tags = {
    defaultExperience       = "Azure Table"
    hidden-cosmos-mmspecial = ""
    hidden-workload-type    = "Learning"
  }
  analytical_storage {
    schema_type = "WellDefined"
  }
  backup {
    tier = "Continuous7Days"
    type = "Continuous"
  }
  capabilities {
    name = "EnableServerless"
  }
  capabilities {
    name = "EnableTable"
  }
  capacity {
    total_throughput_limit = 4000
  }
  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 86400
    max_staleness_prefix    = 1000000
  }
  geo_location {
    failover_priority = 0
    location          = var.location
    zone_redundant    = false
  }
  identity {
    type = "SystemAssigned"
  }
  depends_on = [
    azurerm_resource_group.res-backend-rg
  ]
}
resource "azurerm_cosmosdb_table" "res-cosmosdb-table" {
  account_name        = var.cosmosdb_name
  name                = "${var.cosmosdb_name}table"
  resource_group_name = azurerm_resource_group.res-backend-rg.name
  depends_on = [
    azurerm_cosmosdb_account.res-cosmosdb-account
  ]
}
resource "azurerm_cosmosdb_sql_role_assignment" "res-cosmosdb-sql-role-assignment" {
  account_name        = var.cosmosdb_name
  principal_id        = var.user_object_id
  resource_group_name = azurerm_resource_group.res-backend-rg.name
  role_definition_id  = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.DocumentDB/databaseAccounts/${var.cosmosdb_name}/sqlRoleDefinitions/00000000-0000-0000-0000-000000000001"
  scope               = azurerm_cosmosdb_account.res-cosmosdb-account.id
}
resource "azurerm_cosmosdb_sql_role_assignment" "res-cosmosdb-sql-role-assignment2" {
  account_name        = var.cosmosdb_name
  principal_id        = var.user_object_id
  resource_group_name = azurerm_resource_group.res-backend-rg.name
  role_definition_id  = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.DocumentDB/databaseAccounts/${var.cosmosdb_name}/sqlRoleDefinitions/00000000-0000-0000-0000-000000000002"
  scope               = azurerm_cosmosdb_account.res-cosmosdb-account.id
}

resource "azurerm_log_analytics_workspace" "res-log-analytics-workspace" {
  location            = var.location
  name                = "DefaultWorkspace-${var.env_name}"
  resource_group_name = azurerm_resource_group.res-backend-rg.name
  depends_on = [
    azurerm_resource_group.res-backend-rg
  ]
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
  large_file_share_enabled          = false
  local_user_enabled                = true
  min_tls_version                   = "TLS1_2"
  nfsv3_enabled                     = false
  public_network_access_enabled     = true
  queue_encryption_key_type         = "Service"
  sftp_enabled                      = false
  shared_access_key_enabled         = true
  table_encryption_key_type         = "Service"
  location                          = var.location
  name                              = "backendstor${random_id.res-ran-id.hex}"
  resource_group_name               = azurerm_resource_group.res-backend-rg.name
  share_properties {
    retention_policy {
      days = 7
    }
  }
  depends_on = [
    azurerm_resource_group.res-backend-rg
  ]
}
resource "azurerm_role_assignment" "res-role-assi" {
  principal_id         = var.user_object_id
  principal_type       = "User"
  role_definition_name = "Storage Blob Data Contributor"
  scope                = azurerm_storage_account.res-storage-account.id
  depends_on = [
    azurerm_resource_group.res-backend-rg, azurerm_storage_account.res-storage-account
  ]
}
resource "azurerm_role_assignment" "res-role-assi2" {
  principal_id         = var.user_object_id
  principal_type       = "User"
  role_definition_name = "Storage Blob Data Reader"
  scope                = azurerm_storage_account.res-storage-account.id
  depends_on = [
    azurerm_resource_group.res-backend-rg, azurerm_storage_account.res-storage-account
  ]
}
resource "azurerm_storage_container" "res-storage-container" {
  name               = "azure-webjobs-hosts"
  storage_account_id = azurerm_storage_account.res-storage-account.id
  depends_on = [
    azurerm_resource_group.res-backend-rg, azurerm_storage_account.res-storage-account, azurerm_storage_account_queue_properties.res-stor-acc-queu-prop
  ]
}
resource "azurerm_storage_container" "res-storage-container1" {
  name               = "azure-webjobs-secrets"
  storage_account_id = azurerm_storage_account.res-storage-account.id
  depends_on = [
    azurerm_resource_group.res-backend-rg, azurerm_storage_account.res-storage-account, azurerm_storage_account_queue_properties.res-stor-acc-queu-prop
  ]
}
resource "azurerm_storage_container" "res-storage-container2" {
  name               = "scm-releases"
  storage_account_id = azurerm_storage_account.res-storage-account.id
  depends_on = [
    azurerm_resource_group.res-backend-rg, azurerm_storage_account.res-storage-account, azurerm_storage_account_queue_properties.res-stor-acc-queu-prop
  ]
}
resource "azurerm_storage_account_queue_properties" "res-stor-acc-queu-prop" {
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
resource "azurerm_storage_table" "res-storage-table" {
  name                 = "AzureFunctionsDiagnosticEvents202507"
  storage_account_name = azurerm_storage_account.res-storage-account.name
  depends_on = [
    azurerm_storage_account.res-storage-account
  ]
}
resource "azurerm_service_plan" "res-service-plan" {
  location            = var.location
  name                = "ASP-${var.resource_group_name}-9669"
  os_type             = "Linux"
  resource_group_name = azurerm_resource_group.res-backend-rg.name
  sku_name            = "Y1"
  depends_on = [
    azurerm_resource_group.res-backend-rg
  ]
}
resource "time_sleep" "res-app-service-sleep" {
  create_duration = "600s"
  depends_on = [
    azurerm_service_plan.res-service-plan
  ]
}


resource "azurerm_linux_function_app" "res-lin-func-app" {
  name                          = "jcloud-${var.env_name}funcapp-${random_id.res-ran-id.hex}"
  resource_group_name           = azurerm_resource_group.res-backend-rg.name
  location                      = var.location
  public_network_access_enabled = true
  service_plan_id               = azurerm_service_plan.res-service-plan.id
  storage_account_name          = azurerm_storage_account.res-storage-account.name
  storage_account_access_key    = azurerm_storage_account.res-storage-account.primary_access_key
  https_only                    = true

  site_config {
    app_scale_limit                        = 200
    always_on                              = false
    http2_enabled                          = false
    use_32_bit_worker                      = false
    vnet_route_all_enabled                 = false
    worker_count                           = 1
    managed_pipeline_mode                  = "Integrated"
    load_balancing_mode                    = "LeastRequests"
    api_management_api_id                  = azurerm_api_management_api.res-api-man-api.id
    ip_restriction_default_action          = "Allow"
    scm_ip_restriction_default_action      = "Allow"
    scm_use_main_ip_restriction            = false
    ftps_state                             = "FtpsOnly"
    application_insights_connection_string = azurerm_application_insights.res-app-insights.connection_string
    application_insights_key               = azurerm_application_insights.res-app-insights.instrumentation_key

    default_documents = [
      "Default.htm",
      "Default.html",
      "Default.asp",
      "index.htm",
      "index.html",
      "iisstart.htm",
      "default.aspx",
      "index.php"
    ]
    application_stack {
      python_version = "3.12"
    }
  }

  sticky_settings {
    app_setting_names = [
      "APPINSIGHTS_INSTRUMENTATIONKEY",
      "APPLICATIONINSIGHTS_CONNECTION_STRING ",
      "APPINSIGHTS_PROFILERFEATURE_VERSION",
      "APPINSIGHTS_SNAPSHOTFEATURE_VERSION",
      "ApplicationInsightsAgent_EXTENSION_VERSION",
      "XDT_MicrosoftApplicationInsights_BaseExtensions",
      "DiagnosticServices_EXTENSION_VERSION",
      "InstrumentationEngine_EXTENSION_VERSION",
      "SnapshotDebugger_EXTENSION_VERSION",
      "XDT_MicrosoftApplicationInsights_Mode",
      "XDT_MicrosoftApplicationInsights_PreemptSdk",
      "APPLICATIONINSIGHTS_CONFIGURATION_CONTENT",
      "XDT_MicrosoftApplicationInsightsJava",
      "XDT_MicrosoftApplicationInsights_NodeJS",
    ]
  }

  tags = {
    "hidden-link: /app-insights-resource-id" = azurerm_application_insights.res-app-insights.id
  }

  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME"      = "python"
    "AzureWebJobsFeatureFlags"      = "EnableWorkerIndexing"
    "AZURE_COSMOS_CONNECTIONSTRING" = "DefaultEndpointsProtocol=https;AccountName=${azurerm_cosmosdb_account.res-cosmosdb-account.name};AccountKey=${azurerm_cosmosdb_account.res-cosmosdb-account.primary_key};TableEndpoint=https://${azurerm_cosmosdb_account.res-cosmosdb-account.name}.table.cosmos.azure.com:443/;"
    "AZURE_COSMOS_TABLENAME"        = "${var.cosmosdb_name}table"
  }

  depends_on = [
    azurerm_service_plan.res-service-plan, azurerm_resource_group.res-backend-rg, azurerm_storage_account.res-storage-account, azurerm_api_management.res-api-management
  ]
}

resource "azurerm_application_insights" "res-app-insights" {
  application_type                      = "web"
  location                              = var.location
  name                                  = "${var.env_name}-appinsights"
  workspace_id                          = azurerm_log_analytics_workspace.res-log-analytics-workspace.id
  resource_group_name                   = azurerm_resource_group.res-backend-rg.name
  sampling_percentage                   = 0
  daily_data_cap_in_gb                  = 100
  daily_data_cap_notifications_disabled = false
  disable_ip_masking                    = false
  force_customer_storage_for_profiler   = false
  internet_ingestion_enabled            = true
  internet_query_enabled                = true
  local_authentication_disabled         = false
  retention_in_days                     = 90
  depends_on = [
    azurerm_resource_group.res-backend-rg, azurerm_log_analytics_workspace.res-log-analytics-workspace
  ]
}
resource "azurerm_monitor_diagnostic_setting" "res-mon-diag-set" {
  name                       = "apim-diag"
  target_resource_id         = azurerm_api_management.res-api-management.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-log-analytics-workspace.id

  # Logs: capture request + response + traces
  enabled_log {
    category = "GatewayLogs"
  }

  # Metrics: latency, backend response times, etc.
  enabled_metric {
    category = "AllMetrics"
  }
}
resource "azurerm_monitor_metric_alert" "res-mon-metr-alert" {
  enabled             = false
  name                = "HTTP_Trigger Error Alert"
  resource_group_name = azurerm_resource_group.res-backend-rg.name
  scopes              = [azurerm_application_insights.res-app-insights.id]
  severity            = 1
  window_size         = "PT1M"
  criteria {
    aggregation            = "Count"
    metric_name            = "http_trigger Failures"
    metric_namespace       = "azure.applicationinsights"
    operator               = "GreaterThan"
    threshold              = 1
    skip_metric_validation = true
  }
  depends_on = [
    azurerm_resource_group.res-backend-rg, azurerm_application_insights.res-app-insights
  ]
}
resource "azurerm_monitor_metric_alert" "res-mon-metr-alert2" {
  enabled             = false
  name                = "http_trigger Count"
  resource_group_name = azurerm_resource_group.res-backend-rg.name
  scopes              = [azurerm_application_insights.res-app-insights.id]
  severity            = 2
  window_size         = "PT1M"
  criteria {
    aggregation            = "Total"
    metric_name            = "http_trigger Count"
    metric_namespace       = "azure.applicationinsights"
    operator               = "GreaterThan"
    threshold              = 50
    skip_metric_validation = true
  }
  depends_on = [
    azurerm_resource_group.res-backend-rg, azurerm_application_insights.res-app-insights
  ]
}
resource "azurerm_monitor_scheduled_query_rules_alert_v2" "res-mon-query-rule-alert" {
  display_name          = "Error 500"
  enabled               = false
  evaluation_frequency  = "PT5M"
  location              = var.location
  name                  = "Error 500"
  resource_group_name   = azurerm_resource_group.res-backend-rg.name
  scopes                = [azurerm_application_insights.res-app-insights.id]
  severity              = 1
  target_resource_types = ["microsoft.insights/components"]
  window_duration       = "PT5M"
  criteria {
    operator                = "Equal"
    query                   = "requests\n| where resultCode in (```500```)\n"
    threshold               = 1
    time_aggregation_method = "Count"
    failing_periods {
      minimum_failing_periods_to_trigger_alert = 1
      number_of_evaluation_periods             = 1
    }
  }
  depends_on = [
    azurerm_resource_group.res-backend-rg, azurerm_application_insights.res-app-insights
  ]
}