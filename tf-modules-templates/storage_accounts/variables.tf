variable "storage_account_name" {
  description = "The name of the storage account."
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the storage account."
}

variable "location" {
  description = "The Azure region where the storage account will be created."
}

variable "account_tier" {
  description = "The storage account performance tier (Standard or Premium)."
}

variable "account_replication_type" {
  description = "The type of replication to use for the storage account (LRS, GRS, RAGRS, ZRS)."
}
