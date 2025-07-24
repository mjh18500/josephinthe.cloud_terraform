variable "resource_group_name" {
  type        = string
}

variable "location" {
  type        = string
}

variable "fd_profile_name" {
  type        = string
}

//Storage account name must be unique
variable "storage_account_name" {
  type        = string
}

variable "subscription_id" {
  type        = string
}

variable "cdn_profile_name" {
  type        = string
}

variable "cdn_endpoint_name" {
  type        = string
}
