

data "azurerm_subscription" "primary" {}

output "subscription_id" {
  value = data.azurerm_subscription.primary.id
}

output "tenant_id" {
  value = data.azurerm_subscription.primary.tenant_id
}


data "azurerm_client_config" "current" { }

output "object_id" {
  value = data.azurerm_client_config.current.object_id
}

data "azuread_user" "current_user" {
  object_id = data.azurerm_client_config.current.object_id
}

output "user_principal_name" {
  value = data.azuread_user.current_user.user_principal_name
}