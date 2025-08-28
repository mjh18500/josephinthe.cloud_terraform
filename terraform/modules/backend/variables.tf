variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "api_publisher_name" {
  type = string
}

variable "api_publisher_email" {
  type = string
}

variable "cosmosdb_name" {
  type = string
}

variable "user_object_id" {
  type = string
}

variable "subscription_id" {
  type = string
}

variable "api_title" {
  type        = string
  description = "Display title for the API"
}

variable "env_name" {
  type = string
}