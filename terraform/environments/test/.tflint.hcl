config {
    call_module_type = "all"
}

plugin "azurerm" {
  enabled = true
  version = "0.29.0" # match latest azurerm plugin version
  source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
}

rule "terraform_unused_declarations" {
  enabled = true
}

rule "terraform_required_version" {
  enabled = false
}

rule "terraform_required_providers" {
  enabled = false
}

rule "terraform_deprecated_interpolation" {
  enabled = true
}
 