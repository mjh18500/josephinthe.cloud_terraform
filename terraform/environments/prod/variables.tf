variable "env_name" {
  description = "Prod or Test"
  type        = string
}

variable "location" {
  description = "Location for Azure Resources"
  type        = string
  default     = "eastus2"
}

variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
  default     = "ebeec867-0bac-448a-b3ba-197e572e0b4c"
}

variable "resource_group_name" {
  type = string
}

variable "pr_number" {
  type        = string
  description = "GitHub PR number for preview environments"
}