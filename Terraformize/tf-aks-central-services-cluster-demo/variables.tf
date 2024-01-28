# Resource groups
variable "rg_name" {
    type = string
    description = "resource group name"
}

variable "rg_location" {
    type = string
    description = "contains the resource group location"
}

variable "rg_tags" {
  type    = map(string)
  description = "manages tags"
}

# Service Principal

variable "service_principal_name" {
  type = string
}


# keyvault
variable "keyvault_name" {
    type = string
}
