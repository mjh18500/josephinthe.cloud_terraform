variable "env_name" {
  description = "Prod or Test"
  type        = string
}

variable "location" {
  description = "Location for Azure Resources"
  type        = string
}

variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "resource_group_name" {
  type = string
}

variable "pr_number" {
  type        = string
  description = "GitHub PR number for preview environments"
}

variable "user_object_id" {
  description = "User Object ID used for role assigments"
  type        = string
}