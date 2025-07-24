resource "azurerm_resource_group" "res-0" {
  location = "eastus2"
  name     = "Dev_API_ResourceGroup"
}
resource "azurerm_api_management" "res-1" {
  location            = "eastus2"
  name                = "dev00functionapp-apim"
  publisher_email     = "mjh18500@gmail.com"
  publisher_name      = "Josephinthe.cloud"
  resource_group_name = "Dev_API_ResourceGroup"
  sku_name            = "Developer_1"
  depends_on = [
    azurerm_resource_group.res-0
  ]
}
resource "azurerm_api_management_api" "res-2" {
  api_management_name = "dev00functionapp-apim"
  description         = "Import from \"dev00functionapp\" Function App"
  name                = "dev00functionapp"
  resource_group_name = "Dev_API_ResourceGroup"
  revision            = "1"
  depends_on = [
    azurerm_api_management.res-1
  ]
}
resource "azurerm_api_management_api_operation" "res-3" {
  api_management_name = "dev00functionapp-apim"
  api_name            = "dev00functionapp"
  display_name        = "http_trigger"
  method              = "POST"
  operation_id        = "http-trigger"
  resource_group_name = "Dev_API_ResourceGroup"
  url_template        = "/http_trigger"
  depends_on = [
    azurerm_api_management_api.res-2
  ]
}
resource "azurerm_api_management_api_operation_policy" "res-4" {
  api_management_name = "dev00functionapp-apim"
  api_name            = "dev00functionapp"
  operation_id        = "http-trigger"
  resource_group_name = "Dev_API_ResourceGroup"
  depends_on = [
    azurerm_api_management_api_operation.res-3
  ]
}
resource "azurerm_api_management_api" "res-6" {
  api_management_name = "dev00functionapp-apim"
  name                = "echo-api"
  resource_group_name = "Dev_API_ResourceGroup"
  revision            = "1"
  depends_on = [
    azurerm_api_management.res-1
  ]
}
resource "azurerm_api_management_api_operation" "res-7" {
  api_management_name = "dev00functionapp-apim"
  api_name            = "echo-api"
  description         = "A demonstration of a POST call based on the echo backend above. The request body is expected to contain JSON-formatted data (see example below). A policy is used to automatically transform any request sent in JSON directly to XML. In a real-world scenario this could be used to enable modern clients to speak to a legacy backend."
  display_name        = "Create resource"
  method              = "POST"
  operation_id        = "create-resource"
  resource_group_name = "Dev_API_ResourceGroup"
  url_template        = "/resource"
  response {
    status_code = 200
  }
  depends_on = [
    azurerm_api_management_api.res-6
  ]
}
resource "azurerm_api_management_api_operation_policy" "res-8" {
  api_management_name = "dev00functionapp-apim"
  api_name            = "echo-api"
  operation_id        = "create-resource"
  resource_group_name = "Dev_API_ResourceGroup"
  depends_on = [
    azurerm_api_management_api_operation.res-7
  ]
}
resource "azurerm_api_management_api_operation" "res-9" {
  api_management_name = "dev00functionapp-apim"
  api_name            = "echo-api"
  description         = "A demonstration of a PUT call handled by the same \"echo\" backend as above. You can now specify a request body in addition to headers and it will be returned as well."
  display_name        = "Modify Resource"
  method              = "PUT"
  operation_id        = "modify-resource"
  resource_group_name = "Dev_API_ResourceGroup"
  url_template        = "/resource"
  response {
    status_code = 200
  }
  depends_on = [
    azurerm_api_management_api.res-6
  ]
}
resource "azurerm_api_management_api_operation" "res-10" {
  api_management_name = "dev00functionapp-apim"
  api_name            = "echo-api"
  description         = "A demonstration of a DELETE call which traditionally deletes the resource. It is based on the same \"echo\" backend as in all other operations so nothing is actually deleted."
  display_name        = "Remove resource"
  method              = "DELETE"
  operation_id        = "remove-resource"
  resource_group_name = "Dev_API_ResourceGroup"
  url_template        = "/resource"
  response {
    status_code = 200
  }
  depends_on = [
    azurerm_api_management_api.res-6
  ]
}
resource "azurerm_api_management_api_operation" "res-11" {
  api_management_name = "dev00functionapp-apim"
  api_name            = "echo-api"
  description         = "The HEAD operation returns only headers. In this demonstration a policy is used to set additional headers when the response is returned and to enable JSONP."
  display_name        = "Retrieve header only"
  method              = "HEAD"
  operation_id        = "retrieve-header-only"
  resource_group_name = "Dev_API_ResourceGroup"
  url_template        = "/resource"
  response {
    status_code = 200
  }
  depends_on = [
    azurerm_api_management_api.res-6
  ]
}
resource "azurerm_api_management_api_operation_policy" "res-12" {
  api_management_name = "dev00functionapp-apim"
  api_name            = "echo-api"
  operation_id        = "retrieve-header-only"
  resource_group_name = "Dev_API_ResourceGroup"
  depends_on = [
    azurerm_api_management_api_operation.res-11
  ]
}
resource "azurerm_api_management_api_operation" "res-13" {
  api_management_name = "dev00functionapp-apim"
  api_name            = "echo-api"
  description         = "A demonstration of a GET call on a sample resource. It is handled by an \"echo\" backend which returns a response equal to the request (the supplied headers and body are being returned as received)."
  display_name        = "Retrieve resource"
  method              = "GET"
  operation_id        = "retrieve-resource"
  resource_group_name = "Dev_API_ResourceGroup"
  url_template        = "/resource"
  response {
    description = "Returned in all cases."
    status_code = 200
  }
  depends_on = [
    azurerm_api_management_api.res-6
  ]
}
resource "azurerm_api_management_api_operation" "res-14" {
  api_management_name = "dev00functionapp-apim"
  api_name            = "echo-api"
  description         = "A demonstration of a GET call with caching enabled on the same \"echo\" backend as above. Cache TTL is set to 1 hour. When you make the first request the headers you supplied will be cached. Subsequent calls will return the same headers as the first time even if you change them in your request."
  display_name        = "Retrieve resource (cached)"
  method              = "GET"
  operation_id        = "retrieve-resource-cached"
  resource_group_name = "Dev_API_ResourceGroup"
  url_template        = "/resource-cached"
  response {
    status_code = 200
  }
  depends_on = [
    azurerm_api_management_api.res-6
  ]
}
resource "azurerm_api_management_api_operation_policy" "res-15" {
  api_management_name = "dev00functionapp-apim"
  api_name            = "echo-api"
  operation_id        = "retrieve-resource-cached"
  resource_group_name = "Dev_API_ResourceGroup"
  depends_on = [
    azurerm_api_management_api_operation.res-14
  ]
}
resource "azurerm_api_management_backend" "res-17" {
  api_management_name = "dev00functionapp-apim"
  description         = "dev00functionapp"
  name                = "dev00functionapp"
  protocol            = "http"
  resource_group_name = "Dev_API_ResourceGroup"
  resource_id         = "https://management.azure.com/subscriptions/ebeec867-0bac-448a-b3ba-197e572e0b4c/resourceGroups/Dev_API_ResourceGroup/providers/Microsoft.Web/sites/dev00functionapp"
  url                 = "https://dev00functionapp.azurewebsites.net/api"
  credentials {
    header = {
      x-functions-key = "{{dev00functionapp-key}}"
    }
  }
  depends_on = [
    azurerm_api_management.res-1
  ]
}
resource "azurerm_api_management_group" "res-18" {
  api_management_name = "dev00functionapp-apim"
  description         = "Administrators is a built-in group containing the admin email account provided at the time of service creation. Its membership is managed by the system."
  display_name        = "Administrators"
  name                = "administrators"
  resource_group_name = "Dev_API_ResourceGroup"
  type                = "system"
  depends_on = [
    azurerm_api_management.res-1
  ]
}
resource "azurerm_api_management_group_user" "res-19" {
  api_management_name = "dev00functionapp-apim"
  group_name          = "administrators"
  resource_group_name = "Dev_API_ResourceGroup"
  user_id             = "1"
  depends_on = [
    azurerm_api_management_group.res-18
  ]
}
resource "azurerm_api_management_group" "res-20" {
  api_management_name = "dev00functionapp-apim"
  description         = "Developers is a built-in group. Its membership is managed by the system. Signed-in users fall into this group."
  display_name        = "Developers"
  name                = "developers"
  resource_group_name = "Dev_API_ResourceGroup"
  type                = "system"
  depends_on = [
    azurerm_api_management.res-1
  ]
}
resource "azurerm_api_management_group_user" "res-21" {
  api_management_name = "dev00functionapp-apim"
  group_name          = "developers"
  resource_group_name = "Dev_API_ResourceGroup"
  user_id             = "1"
  depends_on = [
    azurerm_api_management_group.res-20
  ]
}
resource "azurerm_api_management_group" "res-22" {
  api_management_name = "dev00functionapp-apim"
  description         = "Guests is a built-in group. Its membership is managed by the system. Unauthenticated users visiting the developer portal fall into this group."
  display_name        = "Guests"
  name                = "guests"
  resource_group_name = "Dev_API_ResourceGroup"
  type                = "system"
  depends_on = [
    azurerm_api_management.res-1
  ]
}
resource "azurerm_api_management_named_value" "res-23" {
  api_management_name = "dev00functionapp-apim"
  display_name        = "dev00functionapp-key"
  name                = "dev00functionapp-key"
  resource_group_name = "Dev_API_ResourceGroup"
  secret              = true
  tags                = ["key", "function", "auto"]
  depends_on = [
    azurerm_api_management.res-1
  ]
}
resource "azurerm_api_management_policy" "res-31" {
  api_management_id = azurerm_api_management.res-1.id
  xml_content       = "<!--\r\n    IMPORTANT:\r\n    - Policy elements can appear only within the <inbound>, <outbound>, <backend> section elements.\r\n    - Only the <forward-request> policy element can appear within the <backend> section element.\r\n    - To apply a policy to the incoming request (before it is forwarded to the backend service), place a corresponding policy element within the <inbound> section element.\r\n    - To apply a policy to the outgoing response (before it is sent back to the caller), place a corresponding policy element within the <outbound> section element.\r\n    - To add a policy position the cursor at the desired insertion point and click on the round button associated with the policy.\r\n    - To remove a policy, delete the corresponding policy statement from the policy document.\r\n    - Policies are applied in the order of their appearance, from the top down.\r\n-->\r\n<policies>\r\n\t<inbound />\r\n\t<backend>\r\n\t\t<forward-request />\r\n\t</backend>\r\n\t<outbound />\r\n</policies>"
}
resource "azurerm_api_management_product" "res-36" {
  api_management_name = "dev00functionapp-apim"
  description         = "Subscribers will be able to run 5 calls/minute up to a maximum of 100 calls/week."
  display_name        = "Starter"
  product_id          = "starter"
  published           = true
  resource_group_name = "Dev_API_ResourceGroup"
  subscriptions_limit = 1
  depends_on = [
    azurerm_api_management.res-1
  ]
}
resource "azurerm_api_management_product_api" "res-38" {
  api_management_name = "dev00functionapp-apim"
  api_name            = "echo-api"
  product_id          = "starter"
  resource_group_name = "Dev_API_ResourceGroup"
  depends_on = [
    azurerm_api_management_product.res-36
  ]
}
resource "azurerm_api_management_product_group" "res-42" {
  api_management_name = "dev00functionapp-apim"
  group_name          = "administrators"
  product_id          = "starter"
  resource_group_name = "Dev_API_ResourceGroup"
  depends_on = [
    azurerm_api_management_product.res-36
  ]
}
resource "azurerm_api_management_product_group" "res-43" {
  api_management_name = "dev00functionapp-apim"
  group_name          = "developers"
  product_id          = "starter"
  resource_group_name = "Dev_API_ResourceGroup"
  depends_on = [
    azurerm_api_management_product.res-36
  ]
}
resource "azurerm_api_management_product_group" "res-44" {
  api_management_name = "dev00functionapp-apim"
  group_name          = "guests"
  product_id          = "starter"
  resource_group_name = "Dev_API_ResourceGroup"
  depends_on = [
    azurerm_api_management_product.res-36
  ]
}
resource "azurerm_api_management_product_policy" "res-45" {
  api_management_name = "dev00functionapp-apim"
  product_id          = "starter"
  resource_group_name = "Dev_API_ResourceGroup"
  depends_on = [
    azurerm_api_management_product.res-36
  ]
}
resource "azurerm_api_management_product" "res-47" {
  api_management_name = "dev00functionapp-apim"
  approval_required   = true
  description         = "Subscribers have completely unlimited access to the API. Administrator approval is required."
  display_name        = "Unlimited"
  product_id          = "unlimited"
  published           = true
  resource_group_name = "Dev_API_ResourceGroup"
  subscriptions_limit = 1
  depends_on = [
    azurerm_api_management.res-1
  ]
}
resource "azurerm_api_management_product_api" "res-49" {
  api_management_name = "dev00functionapp-apim"
  api_name            = "echo-api"
  product_id          = "unlimited"
  resource_group_name = "Dev_API_ResourceGroup"
  depends_on = [
    azurerm_api_management_product.res-47
  ]
}
resource "azurerm_api_management_product_group" "res-53" {
  api_management_name = "dev00functionapp-apim"
  group_name          = "administrators"
  product_id          = "unlimited"
  resource_group_name = "Dev_API_ResourceGroup"
  depends_on = [
    azurerm_api_management_product.res-47
  ]
}
resource "azurerm_api_management_product_group" "res-54" {
  api_management_name = "dev00functionapp-apim"
  group_name          = "developers"
  product_id          = "unlimited"
  resource_group_name = "Dev_API_ResourceGroup"
  depends_on = [
    azurerm_api_management_product.res-47
  ]
}
resource "azurerm_api_management_product_group" "res-55" {
  api_management_name = "dev00functionapp-apim"
  group_name          = "guests"
  product_id          = "unlimited"
  resource_group_name = "Dev_API_ResourceGroup"
  depends_on = [
    azurerm_api_management_product.res-47
  ]
}
resource "azurerm_api_management_subscription" "res-58" {
  allow_tracing       = false
  api_management_name = "dev00functionapp-apim"
  display_name        = ""
  product_id          = "/subscriptions/ebeec867-0bac-448a-b3ba-197e572e0b4c/resourceGroups/Dev_API_ResourceGroup/providers/Microsoft.ApiManagement/service/dev00functionapp-apim/products/starter"
  resource_group_name = "Dev_API_ResourceGroup"
  state               = "active"
  user_id             = azurerm_api_management_user.res-76.id
  depends_on = [
    # One of azurerm_api_management_product.res-36,azurerm_api_management_product_policy.res-45 (can't auto-resolve as their ids are identical)
  ]
}
resource "azurerm_api_management_subscription" "res-59" {
  allow_tracing       = false
  api_management_name = "dev00functionapp-apim"
  display_name        = ""
  product_id          = azurerm_api_management_product.res-47.id
  resource_group_name = "Dev_API_ResourceGroup"
  state               = "active"
  user_id             = azurerm_api_management_user.res-76.id
}
resource "azurerm_api_management_subscription" "res-61" {
  allow_tracing       = false
  api_id              = "/subscriptions/ebeec867-0bac-448a-b3ba-197e572e0b4c/resourceGroups/Dev_API_ResourceGroup/providers/Microsoft.ApiManagement/service/dev00functionapp-apim/apis/dev00functionapp"
  api_management_name = "dev00functionapp-apim"
  display_name        = "public"
  resource_group_name = "Dev_API_ResourceGroup"
  state               = "active"
  user_id             = azurerm_api_management_user.res-76.id
}
resource "azurerm_api_management_email_template" "res-62" {
  api_management_name = "dev00functionapp-apim"
  body                = "<!DOCTYPE html >\r\n<html>\r\n  <head />\r\n  <body>\r\n    <p style=\"font-size:12pt;font-family:'Segoe UI'\">Dear $DevFirstName $DevLastName,</p>\r\n    <p style=\"font-size:12pt;font-family:'Segoe UI'\">\r\n          On behalf of $OrganizationName and our customers we thank you for giving us a try. Your $OrganizationName API account is now closed.\r\n        </p>\r\n    <p style=\"font-size:12pt;font-family:'Segoe UI'\">Thank you,</p>\r\n    <p style=\"font-size:12pt;font-family:'Segoe UI'\">Your $OrganizationName Team</p>\r\n    <a href=\"$DevPortalUrl\">$DevPortalUrl</a>\r\n    <p />\r\n  </body>\r\n</html>"
  resource_group_name = "Dev_API_ResourceGroup"
  subject             = "Thank you for using the $OrganizationName API!"
  template_name       = "AccountClosedDeveloper"
  depends_on = [
    azurerm_api_management.res-1
  ]
}
resource "azurerm_api_management_email_template" "res-63" {
  api_management_name = "dev00functionapp-apim"
  body                = "<!DOCTYPE html >\r\n<html>\r\n  <head />\r\n  <body>\r\n    <p style=\"font-size:12pt;font-family:'Segoe UI'\">Dear $DevFirstName $DevLastName,</p>\r\n    <p style=\"font-size:12pt;font-family:'Segoe UI'\">\r\n          We are happy to let you know that your request to publish the $AppName application in the application gallery has been approved. Your application has been published and can be viewed <a href=\"http://$DevPortalUrl/Applications/Details/$AppId\">here</a>.\r\n        </p>\r\n    <p style=\"font-size:12pt;font-family:'Segoe UI'\">Best,</p>\r\n    <p style=\"font-size:12pt;font-family:'Segoe UI'\">The $OrganizationName API Team</p>\r\n  </body>\r\n</html>"
  resource_group_name = "Dev_API_ResourceGroup"
  subject             = "Your application $AppName is published in the application gallery"
  template_name       = "ApplicationApprovedNotificationMessage"
  depends_on = [
    azurerm_api_management.res-1
  ]
}
resource "azurerm_api_management_email_template" "res-64" {
  api_management_name = "dev00functionapp-apim"
  body                = "<!DOCTYPE html >\r\n<html>\r\n  <head>\r\n    <meta charset=\"UTF-8\" />\r\n    <title>Letter</title>\r\n  </head>\r\n  <body>\r\n    <table width=\"100%\">\r\n      <tr>\r\n        <td>\r\n          <p style=\"font-size:12pt;font-family:'Segoe UI'\">Dear $DevFirstName $DevLastName,</p>\r\n          <p style=\"font-size:12pt;font-family:'Segoe UI'\"></p>\r\n          <p style=\"font-size:12pt;font-family:'Segoe UI'\">Thank you for joining the $OrganizationName API program! We host a growing number of cool APIs and strive to provide an awesome experience for API developers.</p>\r\n          <p style=\"font-size:12pt;font-family:'Segoe UI'\">First order of business is to activate your account and get you going. To that end, please click on the following link:</p>\r\n          <p style=\"font-size:12pt;font-family:'Segoe UI'\">\r\n            <a id=\"confirmUrl\" href=\"$ConfirmUrl\" style=\"text-decoration:none\">\r\n              <strong>$ConfirmUrl</strong>\r\n            </a>\r\n          </p>\r\n          <p style=\"font-size:12pt;font-family:'Segoe UI'\">If clicking the link does not work, please copy-and-paste or re-type it into your browser's address bar and hit \"Enter\".</p>\r\n          <p style=\"font-size:12pt;font-family:'Segoe UI'\">Thank you,</p>\r\n          <p style=\"font-size:12pt;font-family:'Segoe UI'\">$OrganizationName API Team</p>\r\n          <p style=\"font-size:12pt;font-family:'Segoe UI'\">\r\n            <a href=\"$DevPortalUrl\">$DevPortalUrl</a>\r\n          </p>\r\n        </td>\r\n      </tr>\r\n    </table>\r\n  </body>\r\n</html>"
  resource_group_name = "Dev_API_ResourceGroup"
  subject             = "Please confirm your new $OrganizationName API account"
  template_name       = "ConfirmSignUpIdentityDefault"
  depends_on = [
    azurerm_api_management.res-1
  ]
}
resource "azurerm_api_management_email_template" "res-65" {
  api_management_name = "dev00functionapp-apim"
  body                = "<!DOCTYPE html >\r\n<html>\r\n  <head>\r\n    <meta charset=\"UTF-8\" />\r\n    <title>Letter</title>\r\n  </head>\r\n  <body>\r\n    <table width=\"100%\">\r\n      <tr>\r\n        <td>\r\n          <p style=\"font-size:12pt;font-family:'Segoe UI'\">Dear $DevFirstName $DevLastName,</p>\r\n          <p style=\"font-size:12pt;font-family:'Segoe UI'\"></p>\r\n          <p style=\"font-size:12pt;font-family:'Segoe UI'\">You are receiving this email because you made a change to the email address on your $OrganizationName API account.</p>\r\n          <p style=\"font-size:12pt;font-family:'Segoe UI'\">Please click on the following link to confirm the change:</p>\r\n          <p style=\"font-size:12pt;font-family:'Segoe UI'\">\r\n            <a id=\"confirmUrl\" href=\"$ConfirmUrl\" style=\"text-decoration:none\">\r\n              <strong>$ConfirmUrl</strong>\r\n            </a>\r\n          </p>\r\n          <p style=\"font-size:12pt;font-family:'Segoe UI'\">If clicking the link does not work, please copy-and-paste or re-type it into your browser's address bar and hit \"Enter\".</p>\r\n          <p style=\"font-size:12pt;font-family:'Segoe UI'\">Thank you,</p>\r\n          <p style=\"font-size:12pt;font-family:'Segoe UI'\">$OrganizationName API Team</p>\r\n          <p style=\"font-size:12pt;font-family:'Segoe UI'\">\r\n            <a href=\"$DevPortalUrl\">$DevPortalUrl</a>\r\n          </p>\r\n        </td>\r\n      </tr>\r\n    </table>\r\n  </body>\r\n</html>"
  resource_group_name = "Dev_API_ResourceGroup"
  subject             = "Please confirm the new email associated with your $OrganizationName API account"
  template_name       = "EmailChangeIdentityDefault"
  depends_on = [
    azurerm_api_management.res-1
  ]
}
resource "azurerm_api_management_email_template" "res-66" {
  api_management_name = "dev00functionapp-apim"
  body                = "<!DOCTYPE html >\r\n<html>\r\n  <head />\r\n  <body>\r\n    <p style=\"font-size:12pt;font-family:'Segoe UI'\">Dear $DevFirstName $DevLastName,</p>\r\n    <p style=\"font-size:12pt;font-family:'Segoe UI'\">\r\n          Your account has been created. Please follow the link below to visit the $OrganizationName developer portal and claim it:\r\n        </p>\r\n    <p style=\"font-size:12pt;font-family:'Segoe UI'\">\r\n      <a href=\"$ConfirmUrl\">$ConfirmUrl</a>\r\n    </p>\r\n    <p style=\"font-size:12pt;font-family:'Segoe UI'\">Best,</p>\r\n    <p style=\"font-size:12pt;font-family:'Segoe UI'\">The $OrganizationName API Team</p>\r\n  </body>\r\n</html>"
  resource_group_name = "Dev_API_ResourceGroup"
  subject             = "You are invited to join the $OrganizationName developer network"
  template_name       = "InviteUserNotificationMessage"
  depends_on = [
    azurerm_api_management.res-1
  ]
}
resource "azurerm_api_management_email_template" "res-67" {
  api_management_name = "dev00functionapp-apim"
  body                = "<!DOCTYPE html >\r\n<html>\r\n  <head />\r\n  <body>\r\n    <p style=\"font-size:12pt;font-family:'Segoe UI'\">Dear $DevFirstName $DevLastName,</p>\r\n    <p style=\"font-size:12pt;font-family:'Segoe UI'\">This is a brief note to let you know that $CommenterFirstName $CommenterLastName made the following comment on the issue $IssueName you created:</p>\r\n    <p style=\"font-size:12pt;font-family:'Segoe UI'\">$CommentText</p>\r\n    <p style=\"font-size:12pt;font-family:'Segoe UI'\">\r\n          To view the issue on the developer portal click <a href=\"http://$DevPortalUrl/issues/$IssueId\">here</a>.\r\n        </p>\r\n    <p style=\"font-size:12pt;font-family:'Segoe UI'\">Best,</p>\r\n    <p style=\"font-size:12pt;font-family:'Segoe UI'\">The $OrganizationName API Team</p>\r\n  </body>\r\n</html>"
  resource_group_name = "Dev_API_ResourceGroup"
  subject             = "$IssueName issue has a new comment"
  template_name       = "NewCommentNotificationMessage"
  depends_on = [
    azurerm_api_management.res-1
  ]
}
resource "azurerm_api_management_email_template" "res-68" {
  api_management_name = "dev00functionapp-apim"
  body                = "<!DOCTYPE html >\r\n<html>\r\n  <head>\r\n    <meta charset=\"UTF-8\" />\r\n    <title>Letter</title>\r\n  </head>\r\n  <body>\r\n    <h1 style=\"color:#000505;font-size:18pt;font-family:'Segoe UI'\">\r\n          Welcome to <span style=\"color:#003363\">$OrganizationName API!</span></h1>\r\n    <p style=\"font-size:12pt;font-family:'Segoe UI'\">Dear $DevFirstName $DevLastName,</p>\r\n    <p style=\"font-size:12pt;font-family:'Segoe UI'\">Your $OrganizationName API program registration is completed and we are thrilled to have you as a customer. Here are a few important bits of information for your reference:</p>\r\n    <table width=\"100%\" style=\"margin:20px 0\">\r\n      <tr>\r\n            #if ($IdentityProvider == \"Basic\")\r\n            <td width=\"50%\" style=\"height:40px;vertical-align:top;font-family:'Segoe UI';font-size:12pt\">\r\n              Please use the following <strong>username</strong> when signing into any of the $${OrganizationName}-hosted developer portals:\r\n            </td><td style=\"vertical-align:top;font-family:'Segoe UI';font-size:12pt\"><strong>$DevUsername</strong></td>\r\n            #else\r\n            <td width=\"50%\" style=\"height:40px;vertical-align:top;font-family:'Segoe UI';font-size:12pt\">\r\n              Please use the following <strong>$IdentityProvider account</strong> when signing into any of the $${OrganizationName}-hosted developer portals:\r\n            </td><td style=\"vertical-align:top;font-family:'Segoe UI';font-size:12pt\"><strong>$DevUsername</strong></td>            \r\n            #end\r\n          </tr>\r\n      <tr>\r\n        <td style=\"height:40px;vertical-align:top;font-family:'Segoe UI';font-size:12pt\">\r\n              We will direct all communications to the following <strong>email address</strong>:\r\n            </td>\r\n        <td style=\"vertical-align:top;font-family:'Segoe UI';font-size:12pt\">\r\n          <a href=\"mailto:$DevEmail\" style=\"text-decoration:none\">\r\n            <strong>$DevEmail</strong>\r\n          </a>\r\n        </td>\r\n      </tr>\r\n    </table>\r\n    <p style=\"font-size:12pt;font-family:'Segoe UI'\">Best of luck in your API pursuits!</p>\r\n    <p style=\"font-size:12pt;font-family:'Segoe UI'\">$OrganizationName API Team</p>\r\n    <p style=\"font-size:12pt;font-family:'Segoe UI'\">\r\n      <a href=\"http://$DevPortalUrl\">$DevPortalUrl</a>\r\n    </p>\r\n  </body>\r\n</html>"
  resource_group_name = "Dev_API_ResourceGroup"
  subject             = "Welcome to the $OrganizationName API!"
  template_name       = "NewDeveloperNotificationMessage"
  depends_on = [
    azurerm_api_management.res-1
  ]
}
resource "azurerm_api_management_email_template" "res-69" {
  api_management_name = "dev00functionapp-apim"
  body                = "<!DOCTYPE html >\r\n<html>\r\n  <head />\r\n  <body>\r\n    <p style=\"font-size:12pt;font-family:'Segoe UI'\">Dear $DevFirstName $DevLastName,</p>\r\n    <p style=\"font-size:12pt;font-family:'Segoe UI'\">Thank you for contacting us. Our API team will review your issue and get back to you soon.</p>\r\n    <p style=\"font-size:12pt;font-family:'Segoe UI'\">\r\n          Click this <a href=\"http://$DevPortalUrl/issues/$IssueId\">link</a> to view or edit your request.\r\n        </p>\r\n    <p style=\"font-size:12pt;font-family:'Segoe UI'\">Best,</p>\r\n    <p style=\"font-size:12pt;font-family:'Segoe UI'\">The $OrganizationName API Team</p>\r\n  </body>\r\n</html>"
  resource_group_name = "Dev_API_ResourceGroup"
  subject             = "Your request $IssueName was received"
  template_name       = "NewIssueNotificationMessage"
  depends_on = [
    azurerm_api_management.res-1
  ]
}
resource "azurerm_api_management_email_template" "res-70" {
  api_management_name = "dev00functionapp-apim"
  body                = "<!DOCTYPE html >\r\n<html>\r\n  <head />\r\n  <body>\r\n    <table width=\"100%\">\r\n      <tr>\r\n        <td>\r\n          <p style=\"font-size:12pt;font-family:'Segoe UI'\">Dear $DevFirstName $DevLastName,</p>\r\n          <p style=\"font-size:12pt;font-family:'Segoe UI'\"></p>\r\n          <p style=\"font-size:12pt;font-family:'Segoe UI'\">The password of your $OrganizationName API account has been reset, per your request.</p>\r\n          <p style=\"font-size:12pt;font-family:'Segoe UI'\">\r\n                Your new password is: <strong>$DevPassword</strong></p>\r\n          <p style=\"font-size:12pt;font-family:'Segoe UI'\">Please make sure to change it next time you sign in.</p>\r\n          <p style=\"font-size:12pt;font-family:'Segoe UI'\">Thank you,</p>\r\n          <p style=\"font-size:12pt;font-family:'Segoe UI'\">$OrganizationName API Team</p>\r\n          <p style=\"font-size:12pt;font-family:'Segoe UI'\">\r\n            <a href=\"$DevPortalUrl\">$DevPortalUrl</a>\r\n          </p>\r\n        </td>\r\n      </tr>\r\n    </table>\r\n  </body>\r\n</html>"
  resource_group_name = "Dev_API_ResourceGroup"
  subject             = "Your password was reset"
  template_name       = "PasswordResetByAdminNotificationMessage"
  depends_on = [
    azurerm_api_management.res-1
  ]
}
resource "azurerm_api_management_email_template" "res-71" {
  api_management_name = "dev00functionapp-apim"
  body                = "<!DOCTYPE html >\r\n<html>\r\n  <head>\r\n    <meta charset=\"UTF-8\" />\r\n    <title>Letter</title>\r\n  </head>\r\n  <body>\r\n    <table width=\"100%\">\r\n      <tr>\r\n        <td>\r\n          <p style=\"font-size:12pt;font-family:'Segoe UI'\">Dear $DevFirstName $DevLastName,</p>\r\n          <p style=\"font-size:12pt;font-family:'Segoe UI'\"></p>\r\n          <p style=\"font-size:12pt;font-family:'Segoe UI'\">You are receiving this email because you requested to change the password on your $OrganizationName API account.</p>\r\n          <p style=\"font-size:12pt;font-family:'Segoe UI'\">Please click on the link below and follow instructions to create your new password:</p>\r\n          <p style=\"font-size:12pt;font-family:'Segoe UI'\">\r\n            <a id=\"resetUrl\" href=\"$ConfirmUrl\" style=\"text-decoration:none\">\r\n              <strong>$ConfirmUrl</strong>\r\n            </a>\r\n          </p>\r\n          <p style=\"font-size:12pt;font-family:'Segoe UI'\">If clicking the link does not work, please copy-and-paste or re-type it into your browser's address bar and hit \"Enter\".</p>\r\n          <p style=\"font-size:12pt;font-family:'Segoe UI'\">Thank you,</p>\r\n          <p style=\"font-size:12pt;font-family:'Segoe UI'\">$OrganizationName API Team</p>\r\n          <p style=\"font-size:12pt;font-family:'Segoe UI'\">\r\n            <a href=\"$DevPortalUrl\">$DevPortalUrl</a>\r\n          </p>\r\n        </td>\r\n      </tr>\r\n    </table>\r\n  </body>\r\n</html>"
  resource_group_name = "Dev_API_ResourceGroup"
  subject             = "Your password change request"
  template_name       = "PasswordResetIdentityDefault"
  depends_on = [
    azurerm_api_management.res-1
  ]
}
resource "azurerm_api_management_email_template" "res-72" {
  api_management_name = "dev00functionapp-apim"
  body                = "<!DOCTYPE html >\r\n<html>\r\n  <head />\r\n  <body>\r\n    <p style=\"font-size:12pt;font-family:'Segoe UI'\">Greetings $DevFirstName $DevLastName!</p>\r\n    <p style=\"font-size:12pt;font-family:'Segoe UI'\">\r\n          Thank you for subscribing to the <a href=\"http://$DevPortalUrl/products/$ProdId\"><strong>$ProdName</strong></a> and welcome to the $OrganizationName developer community. We are delighted to have you as part of the team and are looking forward to the amazing applications you will build using our API!\r\n        </p>\r\n    <p style=\"font-size:12pt;font-family:'Segoe UI'\">Below are a few subscription details for your reference:</p>\r\n    <p style=\"font-size:12pt;font-family:'Segoe UI'\">\r\n      <ul>\r\n            #if ($SubStartDate != \"\")\r\n            <li style=\"font-size:12pt;font-family:'Segoe UI'\">Start date: $SubStartDate</li>\r\n            #end\r\n            \r\n            #if ($SubTerm != \"\")\r\n            <li style=\"font-size:12pt;font-family:'Segoe UI'\">Subscription term: $SubTerm</li>\r\n            #end\r\n          </ul>\r\n    </p>\r\n    <p style=\"font-size:12pt;font-family:'Segoe UI'\">\r\n            Visit the developer <a href=\"http://$DevPortalUrl/developer\">profile area</a> to manage your subscription and subscription keys\r\n        </p>\r\n    <p style=\"font-size:12pt;font-family:'Segoe UI'\">A couple of pointers to help get you started:</p>\r\n    <p style=\"font-size:12pt;font-family:'Segoe UI'\">\r\n      <strong>\r\n        <a href=\"http://$DevPortalUrl/docs/services?product=$ProdId\">Learn about the API</a>\r\n      </strong>\r\n    </p>\r\n    <p style=\"font-size:12pt;font-family:'Segoe UI'\">The API documentation provides all information necessary to make a request and to process a response. Code samples are provided per API operation in a variety of languages. Moreover, an interactive console allows making API calls directly from the developer portal without writing any code.</p>\r\n    <p style=\"font-size:12pt;font-family:'Segoe UI'\">\r\n      <strong>\r\n        <a href=\"http://$DevPortalUrl/applications\">Feature your app in the app gallery</a>\r\n      </strong>\r\n    </p>\r\n    <p style=\"font-size:12pt;font-family:'Segoe UI'\">You can publish your application on our gallery for increased visibility to potential new users.</p>\r\n    <p style=\"font-size:12pt;font-family:'Segoe UI'\">\r\n      <strong>\r\n        <a href=\"http://$DevPortalUrl/issues\">Stay in touch</a>\r\n      </strong>\r\n    </p>\r\n    <p style=\"font-size:12pt;font-family:'Segoe UI'\">\r\n          If you have an issue, a question, a suggestion, a request, or if you just want to tell us something, go to the <a href=\"http://$DevPortalUrl/issues\">Issues</a> page on the developer portal and create a new topic.\r\n        </p>\r\n    <p style=\"font-size:12pt;font-family:'Segoe UI'\">Happy hacking,</p>\r\n    <p style=\"font-size:12pt;font-family:'Segoe UI'\">The $OrganizationName API Team</p>\r\n    <a style=\"font-size:12pt;font-family:'Segoe UI'\" href=\"http://$DevPortalUrl\">$DevPortalUrl</a>\r\n  </body>\r\n</html>"
  resource_group_name = "Dev_API_ResourceGroup"
  subject             = "Your subscription to the $ProdName"
  template_name       = "PurchaseDeveloperNotificationMessage"
  depends_on = [
    azurerm_api_management.res-1
  ]
}
resource "azurerm_api_management_email_template" "res-73" {
  api_management_name = "dev00functionapp-apim"
  body                = "<!DOCTYPE html >\r\n<html>\r\n  <head>\r\n    <style>\r\n          body {font-size:12pt; font-family:\"Segoe UI\",\"Segoe WP\",\"Tahoma\",\"Arial\",\"sans-serif\";}\r\n          .alert { color: red; }\r\n          .child1 { padding-left: 20px; }\r\n          .child2 { padding-left: 40px; }\r\n          .number { text-align: right; }\r\n          .text { text-align: left; }\r\n          th, td { padding: 4px 10px; min-width: 100px; }\r\n          th { background-color: #DDDDDD;}\r\n        </style>\r\n  </head>\r\n  <body>\r\n    <p>Greetings $DevFirstName $DevLastName!</p>\r\n    <p>\r\n          You are approaching the quota limit on you subscription to the <strong>$ProdName</strong> product (primary key $SubPrimaryKey).\r\n          #if ($QuotaResetDate != \"\")\r\n          This quota will be renewed on $QuotaResetDate.\r\n          #else\r\n          This quota will not be renewed.\r\n          #end\r\n        </p>\r\n    <p>Below are details on quota usage for the subscription:</p>\r\n    <p>\r\n      <table>\r\n        <thead>\r\n          <th class=\"text\">Quota Scope</th>\r\n          <th class=\"number\">Calls</th>\r\n          <th class=\"number\">Call Quota</th>\r\n          <th class=\"number\">Bandwidth</th>\r\n          <th class=\"number\">Bandwidth Quota</th>\r\n        </thead>\r\n        <tbody>\r\n          <tr>\r\n            <td class=\"text\">Subscription</td>\r\n            <td class=\"number\">\r\n                  #if ($CallsAlert == true)\r\n                  <span class=\"alert\">$Calls</span>\r\n                  #else\r\n                  $Calls\r\n                  #end\r\n                </td>\r\n            <td class=\"number\">$CallQuota</td>\r\n            <td class=\"number\">\r\n                  #if ($BandwidthAlert == true)\r\n                  <span class=\"alert\">$Bandwidth</span>\r\n                  #else\r\n                  $Bandwidth\r\n                  #end\r\n                </td>\r\n            <td class=\"number\">$BandwidthQuota</td>\r\n          </tr>\r\n              #foreach ($api in $Apis)\r\n              <tr><td class=\"child1 text\">API: $api.Name</td><td class=\"number\">\r\n                  #if ($api.CallsAlert == true)\r\n                  <span class=\"alert\">$api.Calls</span>\r\n                  #else\r\n                  $api.Calls\r\n                  #end\r\n                </td><td class=\"number\">$api.CallQuota</td><td class=\"number\">\r\n                  #if ($api.BandwidthAlert == true)\r\n                  <span class=\"alert\">$api.Bandwidth</span>\r\n                  #else\r\n                  $api.Bandwidth\r\n                  #end\r\n                </td><td class=\"number\">$api.BandwidthQuota</td></tr>\r\n              #foreach ($operation in $api.Operations)\r\n              <tr><td class=\"child2 text\">Operation: $operation.Name</td><td class=\"number\">\r\n                  #if ($operation.CallsAlert == true)\r\n                  <span class=\"alert\">$operation.Calls</span>\r\n                  #else\r\n                  $operation.Calls\r\n                  #end\r\n                </td><td class=\"number\">$operation.CallQuota</td><td class=\"number\">\r\n                  #if ($operation.BandwidthAlert == true)\r\n                  <span class=\"alert\">$operation.Bandwidth</span>\r\n                  #else\r\n                  $operation.Bandwidth\r\n                  #end\r\n                </td><td class=\"number\">$operation.BandwidthQuota</td></tr>\r\n              #end\r\n              #end\r\n            </tbody>\r\n      </table>\r\n    </p>\r\n    <p>Thank you,</p>\r\n    <p>$OrganizationName API Team</p>\r\n    <a href=\"$DevPortalUrl\">$DevPortalUrl</a>\r\n    <p />\r\n  </body>\r\n</html>"
  resource_group_name = "Dev_API_ResourceGroup"
  subject             = "You are approaching an API quota limit"
  template_name       = "QuotaLimitApproachingDeveloperNotificationMessage"
  depends_on = [
    azurerm_api_management.res-1
  ]
}
resource "azurerm_api_management_email_template" "res-74" {
  api_management_name = "dev00functionapp-apim"
  body                = "<!DOCTYPE html >\r\n<html>\r\n  <head />\r\n  <body>\r\n    <p style=\"font-size:12pt;font-family:'Segoe UI'\">Dear $DevFirstName $DevLastName,</p>\r\n    <p style=\"font-size:12pt;font-family:'Segoe UI'\">\r\n          We would like to inform you that we reviewed your subscription request for the <strong>$ProdName</strong>.\r\n        </p>\r\n        #if ($SubDeclineReason == \"\")\r\n        <p style=\"font-size:12pt;font-family:'Segoe UI'\">Regretfully, we were unable to approve it, as subscriptions are temporarily suspended at this time.</p>\r\n        #else\r\n        <p style=\"font-size:12pt;font-family:'Segoe UI'\">\r\n          Regretfully, we were unable to approve it at this time for the following reason:\r\n          <div style=\"margin-left: 1.5em;\"> $SubDeclineReason </div></p>\r\n        #end\r\n        <p style=\"font-size:12pt;font-family:'Segoe UI'\"> We truly appreciate your interest. </p><p style=\"font-size:12pt;font-family:'Segoe UI'\">All the best,</p><p style=\"font-size:12pt;font-family:'Segoe UI'\">The $OrganizationName API Team</p><a style=\"font-size:12pt;font-family:'Segoe UI'\" href=\"http://$DevPortalUrl\">$DevPortalUrl</a></body>\r\n</html>"
  resource_group_name = "Dev_API_ResourceGroup"
  subject             = "Your subscription request for the $ProdName"
  template_name       = "RejectDeveloperNotificationMessage"
  depends_on = [
    azurerm_api_management.res-1
  ]
}
resource "azurerm_api_management_email_template" "res-75" {
  api_management_name = "dev00functionapp-apim"
  body                = "<!DOCTYPE html >\r\n<html>\r\n  <head />\r\n  <body>\r\n    <p style=\"font-size:12pt;font-family:'Segoe UI'\">Dear $DevFirstName $DevLastName,</p>\r\n    <p style=\"font-size:12pt;font-family:'Segoe UI'\">\r\n          Thank you for your interest in our <strong>$ProdName</strong> API product!\r\n        </p>\r\n    <p style=\"font-size:12pt;font-family:'Segoe UI'\">\r\n          We were delighted to receive your subscription request. We will promptly review it and get back to you at <strong>$DevEmail</strong>.\r\n        </p>\r\n    <p style=\"font-size:12pt;font-family:'Segoe UI'\">Thank you,</p>\r\n    <p style=\"font-size:12pt;font-family:'Segoe UI'\">The $OrganizationName API Team</p>\r\n    <a style=\"font-size:12pt;font-family:'Segoe UI'\" href=\"http://$DevPortalUrl\">$DevPortalUrl</a>\r\n  </body>\r\n</html>"
  resource_group_name = "Dev_API_ResourceGroup"
  subject             = "Your subscription request for the $ProdName"
  template_name       = "RequestDeveloperNotificationMessage"
  depends_on = [
    azurerm_api_management.res-1
  ]
}
resource "azurerm_api_management_user" "res-76" {
  api_management_name = "dev00functionapp-apim"
  email               = "mjh18500@gmail.com"
  first_name          = "Administrator"
  last_name           = ""
  resource_group_name = "Dev_API_ResourceGroup"
  user_id             = "1"
  depends_on = [
    azurerm_api_management.res-1
  ]
}
resource "azurerm_cosmosdb_account" "res-77" {
  automatic_failover_enabled = true
  location                   = "eastus2"
  name                       = "dev00cosmosdb"
  offer_type                 = "Standard"
  resource_group_name        = "Dev_API_ResourceGroup"
  tags = {
    defaultExperience       = "Azure Table"
    hidden-cosmos-mmspecial = ""
    hidden-workload-type    = "Learning"
  }
  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 86400
    max_staleness_prefix    = 1000000
  }
  geo_location {
    failover_priority = 0
    location          = "eastus2"
  }
  identity {
    type = "SystemAssigned"
  }
  depends_on = [
    azurerm_resource_group.res-0
  ]
}
resource "azurerm_cosmosdb_table" "res-78" {
  account_name        = "dev00cosmosdb"
  name                = "dev00cosmosdbtable"
  resource_group_name = "Dev_API_ResourceGroup"
  depends_on = [
    azurerm_cosmosdb_account.res-77
  ]
}
resource "azurerm_cosmosdb_sql_role_assignment" "res-79" {
  account_name        = "dev00cosmosdb"
  principal_id        = "e9bcdf18-cd9d-4805-ad21-594dad348e61"
  resource_group_name = "Dev_API_ResourceGroup"
  role_definition_id  = azurerm_cosmosdb_sql_role_definition.res-82.id
  scope               = azurerm_cosmosdb_account.res-77.id
}
resource "azurerm_cosmosdb_sql_role_assignment" "res-80" {
  account_name        = "dev00cosmosdb"
  principal_id        = "e9bcdf18-cd9d-4805-ad21-594dad348e61"
  resource_group_name = "Dev_API_ResourceGroup"
  role_definition_id  = azurerm_cosmosdb_sql_role_definition.res-81.id
  scope               = azurerm_cosmosdb_account.res-77.id
}
resource "azurerm_cosmosdb_sql_role_definition" "res-81" {
  account_name        = "dev00cosmosdb"
  assignable_scopes   = [azurerm_cosmosdb_account.res-77.id]
  name                = "Cosmos DB Built-in Data Reader"
  resource_group_name = "Dev_API_ResourceGroup"
  type                = "BuiltInRole"
  permissions {
    data_actions = ["Microsoft.DocumentDB/databaseAccounts/readMetadata", "Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/executeQuery", "Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/read", "Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/readChangeFeed"]
  }
}
resource "azurerm_cosmosdb_sql_role_definition" "res-82" {
  account_name        = "dev00cosmosdb"
  assignable_scopes   = [azurerm_cosmosdb_account.res-77.id]
  name                = "Cosmos DB Built-in Data Contributor"
  resource_group_name = "Dev_API_ResourceGroup"
  type                = "BuiltInRole"
  permissions {
    data_actions = ["Microsoft.DocumentDB/databaseAccounts/readMetadata", "Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/*", "Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/*"]
  }
}
resource "azurerm_logic_app_workflow" "res-87" {
  location = "eastus2"
  name     = "SlackLogicApp2"
  parameters = {
    "$connections" = "{\"slack\":{\"connectionId\":\"/subscriptions/ebeec867-0bac-448a-b3ba-197e572e0b4c/resourceGroups/Dev_API_ResourceGroup/providers/Microsoft.Web/connections/SlackConnection2\",\"connectionName\":\"SlackConnection2\",\"id\":\"/subscriptions/ebeec867-0bac-448a-b3ba-197e572e0b4c/providers/Microsoft.Web/locations/eastus2/managedApis/slack\"}}"
  }
  resource_group_name = "Dev_API_ResourceGroup"
  workflow_parameters = {
    "$connections" = "{\"defaultValue\":{},\"type\":\"Object\"}"
  }
  depends_on = [
    azurerm_resource_group.res-0
  ]
}
resource "azurerm_logic_app_action_custom" "res-88" {
  body = jsonencode({
    inputs = {
      body = {
        channel = "C0943S2F1PX"
        text    = "@triggerBody()?['data']?['essentials']?['alertRule']"
      }
      host = {
        connection = {
          name = "@parameters('$connections')['slack']['connectionId']"
        }
      }
      method = "post"
      path   = "/v2/chat.postMessage"
    }
    runAfter = {}
    type     = "ApiConnection"
  })
  logic_app_id = azurerm_logic_app_workflow.res-87.id
  name         = "Post_message_(V2)"
}
resource "azurerm_logic_app_trigger_http_request" "res-89" {
  logic_app_id = azurerm_logic_app_workflow.res-87.id
  name         = "When_a_HTTP_request_is_received"
  schema = jsonencode({
    properties = {
      data = {
        properties = {
          context = {
            properties = {
              activityLog = {
                properties = {
                  authorization = {
                    properties = {
                      action = {
                        type = "string"
                      }
                      scope = {
                        type = "string"
                      }
                    }
                    type = "object"
                  }
                  caller = {
                    type = "string"
                  }
                  claims = {
                    type = "string"
                  }
                  description = {
                    type = "string"
                  }
                  httpRequest = {
                    type = "string"
                  }
                  resourceGroupName = {
                    type = "string"
                  }
                  resourceId = {
                    type = "string"
                  }
                  resourceProviderName = {
                    type = "string"
                  }
                  resourceType = {
                    type = "string"
                  }
                }
                type = "object"
              }
            }
            type = "object"
          }
          properties = {
            properties = {}
            type       = "object"
          }
          status = {
            type = "string"
          }
        }
        type = "object"
      }
      schemaId = {
        type = "string"
      }
    }
    type = "object"
  })
}
resource "azurerm_log_analytics_workspace" "res-90" {
  location            = "eastus2"
  name                = "DefaultWorkspace-ebeec867-0bac-448a-b3ba-197e572e0b4c-EUS2"
  resource_group_name = "Dev_API_ResourceGroup"
  depends_on = [
    azurerm_resource_group.res-0
  ]
}
resource "azurerm_log_analytics_saved_search" "res-91" {
  category                   = "General Exploration"
  display_name               = "All Computers with their most recent data"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-90.id
  name                       = "LogManagement(DefaultWorkspace-ebeec867-0bac-448a-b3ba-197e572e0b4c-EUS2)_General|AlphabeticallySortedComputers"
  query                      = "search not(ObjectName == \"Advisor Metrics\" or ObjectName == \"ManagedSpace\") | summarize AggregatedValue = max(TimeGenerated) by Computer | limit 500000 | sort by Computer asc\r\n// Oql: NOT(ObjectName=\"Advisor Metrics\" OR ObjectName=ManagedSpace) | measure max(TimeGenerated) by Computer | top 500000 | Sort Computer // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
}
resource "azurerm_log_analytics_saved_search" "res-92" {
  category                   = "General Exploration"
  display_name               = "Stale Computers (data older than 24 hours)"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-90.id
  name                       = "LogManagement(DefaultWorkspace-ebeec867-0bac-448a-b3ba-197e572e0b4c-EUS2)_General|StaleComputers"
  query                      = "search not(ObjectName == \"Advisor Metrics\" or ObjectName == \"ManagedSpace\") | summarize lastdata = max(TimeGenerated) by Computer | limit 500000 | where lastdata < ago(24h)\r\n// Oql: NOT(ObjectName=\"Advisor Metrics\" OR ObjectName=ManagedSpace) | measure max(TimeGenerated) as lastdata by Computer | top 500000 | where lastdata < NOW-24HOURS // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
}
resource "azurerm_log_analytics_saved_search" "res-93" {
  category                   = "General Exploration"
  display_name               = "Which Management Group is generating the most data points?"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-90.id
  name                       = "LogManagement(DefaultWorkspace-ebeec867-0bac-448a-b3ba-197e572e0b4c-EUS2)_General|dataPointsPerManagementGroup"
  query                      = "search * | summarize AggregatedValue = count() by ManagementGroupName\r\n// Oql: * | Measure count() by ManagementGroupName // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
}
resource "azurerm_log_analytics_saved_search" "res-94" {
  category                   = "General Exploration"
  display_name               = "Distribution of data Types"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-90.id
  name                       = "LogManagement(DefaultWorkspace-ebeec867-0bac-448a-b3ba-197e572e0b4c-EUS2)_General|dataTypeDistribution"
  query                      = "search * | extend Type = $table | summarize AggregatedValue = count() by Type\r\n// Oql: * | Measure count() by Type // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
}
resource "azurerm_log_analytics_saved_search" "res-95" {
  category                   = "Log Management"
  display_name               = "All Events"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-90.id
  name                       = "LogManagement(DefaultWorkspace-ebeec867-0bac-448a-b3ba-197e572e0b4c-EUS2)_LogManagement|AllEvents"
  query                      = "Event | sort by TimeGenerated desc\r\n// Oql: Type=Event // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
}
resource "azurerm_log_analytics_saved_search" "res-96" {
  category                   = "Log Management"
  display_name               = "All Syslogs"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-90.id
  name                       = "LogManagement(DefaultWorkspace-ebeec867-0bac-448a-b3ba-197e572e0b4c-EUS2)_LogManagement|AllSyslog"
  query                      = "Syslog | sort by TimeGenerated desc\r\n// Oql: Type=Syslog // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
}
resource "azurerm_log_analytics_saved_search" "res-97" {
  category                   = "Log Management"
  display_name               = "All Syslog Records grouped by Facility"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-90.id
  name                       = "LogManagement(DefaultWorkspace-ebeec867-0bac-448a-b3ba-197e572e0b4c-EUS2)_LogManagement|AllSyslogByFacility"
  query                      = "Syslog | summarize AggregatedValue = count() by Facility\r\n// Oql: Type=Syslog | Measure count() by Facility // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
}
resource "azurerm_log_analytics_saved_search" "res-98" {
  category                   = "Log Management"
  display_name               = "All Syslog Records grouped by ProcessName"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-90.id
  name                       = "LogManagement(DefaultWorkspace-ebeec867-0bac-448a-b3ba-197e572e0b4c-EUS2)_LogManagement|AllSyslogByProcessName"
  query                      = "Syslog | summarize AggregatedValue = count() by ProcessName\r\n// Oql: Type=Syslog | Measure count() by ProcessName // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
}
resource "azurerm_log_analytics_saved_search" "res-99" {
  category                   = "Log Management"
  display_name               = "All Syslog Records with Errors"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-90.id
  name                       = "LogManagement(DefaultWorkspace-ebeec867-0bac-448a-b3ba-197e572e0b4c-EUS2)_LogManagement|AllSyslogsWithErrors"
  query                      = "Syslog | where SeverityLevel == \"error\" | sort by TimeGenerated desc\r\n// Oql: Type=Syslog SeverityLevel=error // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
}
resource "azurerm_log_analytics_saved_search" "res-100" {
  category                   = "Log Management"
  display_name               = "Average HTTP Request time by Client IP Address"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-90.id
  name                       = "LogManagement(DefaultWorkspace-ebeec867-0bac-448a-b3ba-197e572e0b4c-EUS2)_LogManagement|AverageHTTPRequestTimeByClientIPAddress"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = avg(TimeTaken) by cIP\r\n// Oql: Type=W3CIISLog | Measure Avg(TimeTaken) by cIP // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
}
resource "azurerm_log_analytics_saved_search" "res-101" {
  category                   = "Log Management"
  display_name               = "Average HTTP Request time by HTTP Method"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-90.id
  name                       = "LogManagement(DefaultWorkspace-ebeec867-0bac-448a-b3ba-197e572e0b4c-EUS2)_LogManagement|AverageHTTPRequestTimeHTTPMethod"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = avg(TimeTaken) by csMethod\r\n// Oql: Type=W3CIISLog | Measure Avg(TimeTaken) by csMethod // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
}
resource "azurerm_log_analytics_saved_search" "res-102" {
  category                   = "Log Management"
  display_name               = "Count of IIS Log Entries by Client IP Address"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-90.id
  name                       = "LogManagement(DefaultWorkspace-ebeec867-0bac-448a-b3ba-197e572e0b4c-EUS2)_LogManagement|CountIISLogEntriesClientIPAddress"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by cIP\r\n// Oql: Type=W3CIISLog | Measure count() by cIP // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
}
resource "azurerm_log_analytics_saved_search" "res-103" {
  category                   = "Log Management"
  display_name               = "Count of IIS Log Entries by HTTP Request Method"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-90.id
  name                       = "LogManagement(DefaultWorkspace-ebeec867-0bac-448a-b3ba-197e572e0b4c-EUS2)_LogManagement|CountIISLogEntriesHTTPRequestMethod"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by csMethod\r\n// Oql: Type=W3CIISLog | Measure count() by csMethod // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
}
resource "azurerm_log_analytics_saved_search" "res-104" {
  category                   = "Log Management"
  display_name               = "Count of IIS Log Entries by HTTP User Agent"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-90.id
  name                       = "LogManagement(DefaultWorkspace-ebeec867-0bac-448a-b3ba-197e572e0b4c-EUS2)_LogManagement|CountIISLogEntriesHTTPUserAgent"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by csUserAgent\r\n// Oql: Type=W3CIISLog | Measure count() by csUserAgent // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
}
resource "azurerm_log_analytics_saved_search" "res-105" {
  category                   = "Log Management"
  display_name               = "Count of IIS Log Entries by Host requested by client"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-90.id
  name                       = "LogManagement(DefaultWorkspace-ebeec867-0bac-448a-b3ba-197e572e0b4c-EUS2)_LogManagement|CountOfIISLogEntriesByHostRequestedByClient"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by csHost\r\n// Oql: Type=W3CIISLog | Measure count() by csHost // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
}
resource "azurerm_log_analytics_saved_search" "res-106" {
  category                   = "Log Management"
  display_name               = "Count of IIS Log Entries by URL for the host \"www.contoso.com\" (replace with your own)"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-90.id
  name                       = "LogManagement(DefaultWorkspace-ebeec867-0bac-448a-b3ba-197e572e0b4c-EUS2)_LogManagement|CountOfIISLogEntriesByURLForHost"
  query                      = "search csHost == \"www.contoso.com\" | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by csUriStem\r\n// Oql: Type=W3CIISLog csHost=\"www.contoso.com\" | Measure count() by csUriStem // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
}
resource "azurerm_log_analytics_saved_search" "res-107" {
  category                   = "Log Management"
  display_name               = "Count of IIS Log Entries by URL requested by client (without query strings)"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-90.id
  name                       = "LogManagement(DefaultWorkspace-ebeec867-0bac-448a-b3ba-197e572e0b4c-EUS2)_LogManagement|CountOfIISLogEntriesByURLRequestedByClient"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by csUriStem\r\n// Oql: Type=W3CIISLog | Measure count() by csUriStem // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
}
resource "azurerm_log_analytics_saved_search" "res-108" {
  category                   = "Log Management"
  display_name               = "Count of Events with level \"Warning\" grouped by Event ID"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-90.id
  name                       = "LogManagement(DefaultWorkspace-ebeec867-0bac-448a-b3ba-197e572e0b4c-EUS2)_LogManagement|CountOfWarningEvents"
  query                      = "Event | where EventLevelName == \"warning\" | summarize AggregatedValue = count() by EventID\r\n// Oql: Type=Event EventLevelName=warning | Measure count() by EventID // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
}
resource "azurerm_log_analytics_saved_search" "res-109" {
  category                   = "Log Management"
  display_name               = "Shows breakdown of response codes"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-90.id
  name                       = "LogManagement(DefaultWorkspace-ebeec867-0bac-448a-b3ba-197e572e0b4c-EUS2)_LogManagement|DisplayBreakdownRespondCodes"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by scStatus\r\n// Oql: Type=W3CIISLog | Measure count() by scStatus // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
}
resource "azurerm_log_analytics_saved_search" "res-110" {
  category                   = "Log Management"
  display_name               = "Count of Events grouped by Event Log"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-90.id
  name                       = "LogManagement(DefaultWorkspace-ebeec867-0bac-448a-b3ba-197e572e0b4c-EUS2)_LogManagement|EventsByEventLog"
  query                      = "Event | summarize AggregatedValue = count() by EventLog\r\n// Oql: Type=Event | Measure count() by EventLog // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
}
resource "azurerm_log_analytics_saved_search" "res-111" {
  category                   = "Log Management"
  display_name               = "Count of Events grouped by Event Source"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-90.id
  name                       = "LogManagement(DefaultWorkspace-ebeec867-0bac-448a-b3ba-197e572e0b4c-EUS2)_LogManagement|EventsByEventSource"
  query                      = "Event | summarize AggregatedValue = count() by Source\r\n// Oql: Type=Event | Measure count() by Source // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
}
resource "azurerm_log_analytics_saved_search" "res-112" {
  category                   = "Log Management"
  display_name               = "Count of Events grouped by Event ID"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-90.id
  name                       = "LogManagement(DefaultWorkspace-ebeec867-0bac-448a-b3ba-197e572e0b4c-EUS2)_LogManagement|EventsByEventsID"
  query                      = "Event | summarize AggregatedValue = count() by EventID\r\n// Oql: Type=Event | Measure count() by EventID // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
}
resource "azurerm_log_analytics_saved_search" "res-113" {
  category                   = "Log Management"
  display_name               = "Events in the Operations Manager Event Log whose Event ID is in the range between 2000 and 3000"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-90.id
  name                       = "LogManagement(DefaultWorkspace-ebeec867-0bac-448a-b3ba-197e572e0b4c-EUS2)_LogManagement|EventsInOMBetween2000to3000"
  query                      = "Event | where EventLog == \"Operations Manager\" and EventID >= 2000 and EventID <= 3000 | sort by TimeGenerated desc\r\n// Oql: Type=Event EventLog=\"Operations Manager\" EventID:[2000..3000] // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
}
resource "azurerm_log_analytics_saved_search" "res-114" {
  category                   = "Log Management"
  display_name               = "Count of Events containing the word \"started\" grouped by EventID"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-90.id
  name                       = "LogManagement(DefaultWorkspace-ebeec867-0bac-448a-b3ba-197e572e0b4c-EUS2)_LogManagement|EventsWithStartedinEventID"
  query                      = "search in (Event) \"started\" | summarize AggregatedValue = count() by EventID\r\n// Oql: Type=Event \"started\" | Measure count() by EventID // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
}
resource "azurerm_log_analytics_saved_search" "res-115" {
  category                   = "Log Management"
  display_name               = "Find the maximum time taken for each page"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-90.id
  name                       = "LogManagement(DefaultWorkspace-ebeec867-0bac-448a-b3ba-197e572e0b4c-EUS2)_LogManagement|FindMaximumTimeTakenForEachPage"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = max(TimeTaken) by csUriStem\r\n// Oql: Type=W3CIISLog | Measure Max(TimeTaken) by csUriStem // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
}
resource "azurerm_log_analytics_saved_search" "res-116" {
  category                   = "Log Management"
  display_name               = "IIS Log Entries for a specific client IP Address (replace with your own)"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-90.id
  name                       = "LogManagement(DefaultWorkspace-ebeec867-0bac-448a-b3ba-197e572e0b4c-EUS2)_LogManagement|IISLogEntriesForClientIP"
  query                      = "search cIP == \"192.168.0.1\" | extend Type = $table | where Type == W3CIISLog | sort by TimeGenerated desc | project csUriStem, scBytes, csBytes, TimeTaken, scStatus\r\n// Oql: Type=W3CIISLog cIP=\"192.168.0.1\" | Select csUriStem,scBytes,csBytes,TimeTaken,scStatus // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
}
resource "azurerm_log_analytics_saved_search" "res-117" {
  category                   = "Log Management"
  display_name               = "All IIS Log Entries"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-90.id
  name                       = "LogManagement(DefaultWorkspace-ebeec867-0bac-448a-b3ba-197e572e0b4c-EUS2)_LogManagement|ListAllIISLogEntries"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | sort by TimeGenerated desc\r\n// Oql: Type=W3CIISLog // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
}
resource "azurerm_log_analytics_saved_search" "res-118" {
  category                   = "Log Management"
  display_name               = "How many connections to Operations Manager's SDK service by day"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-90.id
  name                       = "LogManagement(DefaultWorkspace-ebeec867-0bac-448a-b3ba-197e572e0b4c-EUS2)_LogManagement|NoOfConnectionsToOMSDKService"
  query                      = "Event | where EventID == 26328 and EventLog == \"Operations Manager\" | summarize AggregatedValue = count() by bin(TimeGenerated, 1d) | sort by TimeGenerated desc\r\n// Oql: Type=Event EventID=26328 EventLog=\"Operations Manager\" | Measure count() interval 1DAY // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
}
resource "azurerm_log_analytics_saved_search" "res-119" {
  category                   = "Log Management"
  display_name               = "When did my servers initiate restart?"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-90.id
  name                       = "LogManagement(DefaultWorkspace-ebeec867-0bac-448a-b3ba-197e572e0b4c-EUS2)_LogManagement|ServerRestartTime"
  query                      = "search in (Event) \"shutdown\" and EventLog == \"System\" and Source == \"User32\" and EventID == 1074 | sort by TimeGenerated desc | project TimeGenerated, Computer\r\n// Oql: shutdown Type=Event EventLog=System Source=User32 EventID=1074 | Select TimeGenerated,Computer // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
}
resource "azurerm_log_analytics_saved_search" "res-120" {
  category                   = "Log Management"
  display_name               = "Shows which pages people are getting a 404 for"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-90.id
  name                       = "LogManagement(DefaultWorkspace-ebeec867-0bac-448a-b3ba-197e572e0b4c-EUS2)_LogManagement|Show404PagesList"
  query                      = "search scStatus == 404 | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by csUriStem\r\n// Oql: Type=W3CIISLog scStatus=404 | Measure count() by csUriStem // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
}
resource "azurerm_log_analytics_saved_search" "res-121" {
  category                   = "Log Management"
  display_name               = "Shows servers that are throwing internal server error"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-90.id
  name                       = "LogManagement(DefaultWorkspace-ebeec867-0bac-448a-b3ba-197e572e0b4c-EUS2)_LogManagement|ShowServersThrowingInternalServerError"
  query                      = "search scStatus == 500 | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by sComputerName\r\n// Oql: Type=W3CIISLog scStatus=500 | Measure count() by sComputerName // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
}
resource "azurerm_log_analytics_saved_search" "res-122" {
  category                   = "Log Management"
  display_name               = "Total Bytes received by each Azure Role Instance"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-90.id
  name                       = "LogManagement(DefaultWorkspace-ebeec867-0bac-448a-b3ba-197e572e0b4c-EUS2)_LogManagement|TotalBytesReceivedByEachAzureRoleInstance"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = sum(csBytes) by RoleInstance\r\n// Oql: Type=W3CIISLog | Measure Sum(csBytes) by RoleInstance // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
}
resource "azurerm_log_analytics_saved_search" "res-123" {
  category                   = "Log Management"
  display_name               = "Total Bytes received by each IIS Computer"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-90.id
  name                       = "LogManagement(DefaultWorkspace-ebeec867-0bac-448a-b3ba-197e572e0b4c-EUS2)_LogManagement|TotalBytesReceivedByEachIISComputer"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = sum(csBytes) by Computer | limit 500000\r\n// Oql: Type=W3CIISLog | Measure Sum(csBytes) by Computer | top 500000 // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
}
resource "azurerm_log_analytics_saved_search" "res-124" {
  category                   = "Log Management"
  display_name               = "Total Bytes responded back to clients by Client IP Address"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-90.id
  name                       = "LogManagement(DefaultWorkspace-ebeec867-0bac-448a-b3ba-197e572e0b4c-EUS2)_LogManagement|TotalBytesRespondedToClientsByClientIPAddress"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = sum(scBytes) by cIP\r\n// Oql: Type=W3CIISLog | Measure Sum(scBytes) by cIP // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
}
resource "azurerm_log_analytics_saved_search" "res-125" {
  category                   = "Log Management"
  display_name               = "Total Bytes responded back to clients by each IIS ServerIP Address"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-90.id
  name                       = "LogManagement(DefaultWorkspace-ebeec867-0bac-448a-b3ba-197e572e0b4c-EUS2)_LogManagement|TotalBytesRespondedToClientsByEachIISServerIPAddress"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = sum(scBytes) by sIP\r\n// Oql: Type=W3CIISLog | Measure Sum(scBytes) by sIP // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
}
resource "azurerm_log_analytics_saved_search" "res-126" {
  category                   = "Log Management"
  display_name               = "Total Bytes sent by Client IP Address"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-90.id
  name                       = "LogManagement(DefaultWorkspace-ebeec867-0bac-448a-b3ba-197e572e0b4c-EUS2)_LogManagement|TotalBytesSentByClientIPAddress"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = sum(csBytes) by cIP\r\n// Oql: Type=W3CIISLog | Measure Sum(csBytes) by cIP // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
}
resource "azurerm_log_analytics_saved_search" "res-127" {
  category                   = "Log Management"
  display_name               = "All Events with level \"Warning\""
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-90.id
  name                       = "LogManagement(DefaultWorkspace-ebeec867-0bac-448a-b3ba-197e572e0b4c-EUS2)_LogManagement|WarningEvents"
  query                      = "Event | where EventLevelName == \"warning\" | sort by TimeGenerated desc\r\n// Oql: Type=Event EventLevelName=warning // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
}
resource "azurerm_log_analytics_saved_search" "res-128" {
  category                   = "Log Management"
  display_name               = "Windows Firewall Policy settings have changed"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-90.id
  name                       = "LogManagement(DefaultWorkspace-ebeec867-0bac-448a-b3ba-197e572e0b4c-EUS2)_LogManagement|WindowsFireawallPolicySettingsChanged"
  query                      = "Event | where EventLog == \"Microsoft-Windows-Windows Firewall With Advanced Security/Firewall\" and EventID == 2008 | sort by TimeGenerated desc\r\n// Oql: Type=Event EventLog=\"Microsoft-Windows-Windows Firewall With Advanced Security/Firewall\" EventID=2008 // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
}
resource "azurerm_log_analytics_saved_search" "res-129" {
  category                   = "Log Management"
  display_name               = "On which machines and how many times have Windows Firewall Policy settings changed"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-90.id
  name                       = "LogManagement(DefaultWorkspace-ebeec867-0bac-448a-b3ba-197e572e0b4c-EUS2)_LogManagement|WindowsFireawallPolicySettingsChangedByMachines"
  query                      = "Event | where EventLog == \"Microsoft-Windows-Windows Firewall With Advanced Security/Firewall\" and EventID == 2008 | summarize AggregatedValue = count() by Computer | limit 500000\r\n// Oql: Type=Event EventLog=\"Microsoft-Windows-Windows Firewall With Advanced Security/Firewall\" EventID=2008 | measure count() by Computer | top 500000 // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
}
resource "azurerm_storage_account" "res-722" {
  account_replication_type        = "LRS"
  account_tier                    = "Standard"
  default_to_oauth_authentication = true
  location                        = "eastus2"
  name                            = "dev00apistorageaccount"
  resource_group_name             = "Dev_API_ResourceGroup"
  depends_on = [
    azurerm_resource_group.res-0
  ]
}
resource "azurerm_storage_container" "res-724" {
  name               = "azure-webjobs-hosts"
  storage_account_id = "/subscriptions/ebeec867-0bac-448a-b3ba-197e572e0b4c/resourceGroups/Dev_API_ResourceGroup/providers/Microsoft.Storage/storageAccounts/dev00apistorageaccount"
  depends_on = [
    # One of azurerm_storage_account.res-722,azurerm_storage_account_queue_properties.res-728 (can't auto-resolve as their ids are identical)
  ]
}
resource "azurerm_storage_container" "res-725" {
  name               = "azure-webjobs-secrets"
  storage_account_id = "/subscriptions/ebeec867-0bac-448a-b3ba-197e572e0b4c/resourceGroups/Dev_API_ResourceGroup/providers/Microsoft.Storage/storageAccounts/dev00apistorageaccount"
  depends_on = [
    # One of azurerm_storage_account.res-722,azurerm_storage_account_queue_properties.res-728 (can't auto-resolve as their ids are identical)
  ]
}
resource "azurerm_storage_container" "res-726" {
  name               = "scm-releases"
  storage_account_id = "/subscriptions/ebeec867-0bac-448a-b3ba-197e572e0b4c/resourceGroups/Dev_API_ResourceGroup/providers/Microsoft.Storage/storageAccounts/dev00apistorageaccount"
  depends_on = [
    # One of azurerm_storage_account.res-722,azurerm_storage_account_queue_properties.res-728 (can't auto-resolve as their ids are identical)
  ]
}
resource "azurerm_storage_account_queue_properties" "res-728" {
  storage_account_id = azurerm_storage_account.res-722.id
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
resource "azurerm_storage_table" "res-730" {
  name                 = "AzureFunctionsDiagnosticEvents202507"
  storage_account_name = "dev00apistorageaccount"
}
resource "azurerm_api_connection" "res-731" {
  managed_api_id      = "/subscriptions/ebeec867-0bac-448a-b3ba-197e572e0b4c/providers/Microsoft.Web/locations/eastus2/managedApis/slack"
  name                = "SlackConnection2"
  resource_group_name = "Dev_API_ResourceGroup"
  depends_on = [
    azurerm_resource_group.res-0
  ]
}
resource "azurerm_api_connection" "res-732" {
  managed_api_id = "/subscriptions/ebeec867-0bac-448a-b3ba-197e572e0b4c/providers/Microsoft.Web/locations/eastus2/managedApis/arm"
  name           = "arm"
  parameter_values = {
    "token:grantType" = "code"
  }
  resource_group_name = "Dev_API_ResourceGroup"
  depends_on = [
    azurerm_resource_group.res-0
  ]
}
resource "azurerm_service_plan" "res-733" {
  location            = "eastus2"
  name                = "ASP-DevAPIResourceGroup-9669"
  os_type             = "Linux"
  resource_group_name = "Dev_API_ResourceGroup"
  sku_name            = "Y1"
  depends_on = [
    azurerm_resource_group.res-0
  ]
}
resource "azurerm_function_app_function" "res-738" {
  config_json = jsonencode({
    bindings = [{
      authLevel = "ANONYMOUS"
      direction = "IN"
      name      = "req"
      route     = "http_trigger"
      type      = "httpTrigger"
      }, {
      direction = "OUT"
      name      = "$return"
      type      = "http"
    }]
    entryPoint        = "http_trigger"
    functionDirectory = "/home/site/wwwroot"
    language          = "python"
    name              = "http_trigger"
    scriptFile        = "function_app.py"
  })
  function_app_id = "/subscriptions/ebeec867-0bac-448a-b3ba-197e572e0b4c/resourceGroups/Dev_API_ResourceGroup/providers/Microsoft.Web/sites/dev00functionapp"
  name            = "http_trigger"
}
resource "azurerm_app_service_custom_hostname_binding" "res-739" {
  app_service_name    = "dev00functionapp"
  hostname            = "dev00functionapp.azurewebsites.net"
  resource_group_name = "Dev_API_ResourceGroup"
}
resource "azurerm_monitor_smart_detector_alert_rule" "res-740" {
  description         = "Failure Anomalies notifies you of an unusual rise in the rate of failed HTTP requests or dependency calls."
  detector_type       = "FailureAnomaliesDetector"
  enabled             = false
  frequency           = "PT1M"
  name                = "Failure Anomalies - dev00functionappinsights"
  resource_group_name = "Dev_API_ResourceGroup"
  scope_resource_ids  = ["/subscriptions/ebeec867-0bac-448a-b3ba-197e572e0b4c/resourcegroups/dev_api_resourcegroup/providers/microsoft.insights/components/dev00functionappinsights"]
  severity            = "Sev3"
  action_group {
    ids = ["/subscriptions/ebeec867-0bac-448a-b3ba-197e572e0b4c/resourceGroups/dev_api_resourcegroup/providers/Microsoft.Insights/actionGroups/application insights smart detection"]
  }
  depends_on = [
    azurerm_resource_group.res-0
  ]
}
resource "azurerm_monitor_action_group" "res-741" {
  name                = "Application Insights Smart Detection"
  resource_group_name = "Dev_API_ResourceGroup"
  short_name          = "SmartDetect"
  tags = {
    "Joseph Hernandez" = ""
  }
  email_receiver {
    email_address = "mjh18500@gmail.com"
    name          = "Email mjh18500@gmail.com_-EmailAction-"
  }
  logic_app_receiver {
    callback_url            = "https://prod-08.eastus2.logic.azure.com:443/workflows/03b09dcb39b642b5a56f6e72ef2a9491/triggers/When_a_HTTP_request_is_received/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2FWhen_a_HTTP_request_is_received%2Frun&sv=1.0&sig=ttoccrv8QTivJx1G9GmA2fdWHUSB60yV8oEOWZtYUEQ"
    name                    = "Slack"
    resource_id             = azurerm_logic_app_workflow.res-87.id
    use_common_alert_schema = true
  }
  webhook_receiver {
    name                    = "PagerDuty"
    service_uri             = "https://events.pagerduty.com/integration/b449c29c6f054b09c098e8235c4d09d1/enqueue"
    use_common_alert_schema = true
  }
}
resource "azurerm_application_insights" "res-742" {
  application_type    = "web"
  location            = "eastus2"
  name                = "dev00functionappinsights"
  resource_group_name = "Dev_API_ResourceGroup"
  sampling_percentage = 0
  depends_on = [
    azurerm_resource_group.res-0
  ]
}
resource "azurerm_monitor_metric_alert" "res-743" {
  enabled             = false
  name                = "HTTP_Trigger Error Alert"
  resource_group_name = "Dev_API_ResourceGroup"
  scopes              = ["/subscriptions/ebeec867-0bac-448a-b3ba-197e572e0b4c/resourceGroups/Dev_API_ResourceGroup/providers/microsoft.insights/components/dev00functionappinsights"]
  severity            = 1
  window_size         = "PT1M"
  action {
    action_group_id = "/subscriptions/EBEEC867-0BAC-448A-B3BA-197E572E0B4C/resourceGroups/Dev_API_ResourceGroup/providers/microsoft.insights/actionGroups/Application Insights Smart Detection"
  }
  criteria {
    aggregation      = "Count"
    metric_name      = "http_trigger Failures"
    metric_namespace = "azure.applicationinsights"
    operator         = "GreaterThan"
    threshold        = 1
  }
  depends_on = [
    azurerm_resource_group.res-0
  ]
}
resource "azurerm_monitor_metric_alert" "res-744" {
  frequency           = "PT5M"
  name                = "Overall Duration of Gateway Requests"
  resource_group_name = "Dev_API_ResourceGroup"
  scopes              = ["/subscriptions/ebeec867-0bac-448a-b3ba-197e572e0b4c/resourceGroups/Dev_API_ResourceGroup/providers/Microsoft.ApiManagement/service/dev00functionapp-apim"]
  severity            = 2
  window_size         = "PT12H"
  action {
    action_group_id = "/subscriptions/ebeec867-0bac-448a-b3ba-197e572e0b4c/resourcegroups/dev_api_resourcegroup/providers/microsoft.insights/actiongroups/application insights smart detection"
  }
  criteria {
    aggregation      = "Average"
    metric_name      = "Duration"
    metric_namespace = "microsoft.apimanagement/service"
    operator         = "GreaterThan"
    threshold        = 30000
  }
  depends_on = [
    azurerm_resource_group.res-0
    # One of azurerm_api_management.res-1,azurerm_api_management_policy.res-31 (can't auto-resolve as their ids are identical)
  ]
}
resource "azurerm_monitor_metric_alert" "res-745" {
  enabled             = false
  name                = "http_trigger Count"
  resource_group_name = "Dev_API_ResourceGroup"
  scopes              = ["/subscriptions/ebeec867-0bac-448a-b3ba-197e572e0b4c/resourceGroups/Dev_API_ResourceGroup/providers/microsoft.insights/components/dev00functionappinsights"]
  severity            = 2
  window_size         = "PT1M"
  action {
    action_group_id = "/subscriptions/EBEEC867-0BAC-448A-B3BA-197E572E0B4C/resourceGroups/Dev_API_ResourceGroup/providers/microsoft.insights/actionGroups/Application Insights Smart Detection"
  }
  criteria {
    aggregation      = "Total"
    metric_name      = "http_trigger Count"
    metric_namespace = "azure.applicationinsights"
    operator         = "GreaterThan"
    threshold        = 50
  }
  depends_on = [
    azurerm_resource_group.res-0
  ]
}
resource "azurerm_monitor_scheduled_query_rules_alert_v2" "res-746" {
  display_name          = "Error 500"
  enabled               = false
  evaluation_frequency  = "PT5M"
  location              = "eastus2"
  name                  = "Error 500"
  resource_group_name   = "Dev_API_ResourceGroup"
  scopes                = ["/subscriptions/ebeec867-0bac-448a-b3ba-197e572e0b4c/resourceGroups/Dev_API_ResourceGroup/providers/microsoft.insights/components/dev00functionappinsights"]
  severity              = 1
  target_resource_types = ["microsoft.insights/components"]
  window_duration       = "PT5M"
  action {
    action_groups = ["/subscriptions/EBEEC867-0BAC-448A-B3BA-197E572E0B4C/resourceGroups/Dev_API_ResourceGroup/providers/microsoft.insights/actionGroups/Application Insights Smart Detection"]
  }
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
    azurerm_resource_group.res-0
  ]
}
