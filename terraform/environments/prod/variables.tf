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
}

variable "resource_group_name" {
  type = string
}