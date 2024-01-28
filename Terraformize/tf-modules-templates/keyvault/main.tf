data "azurerm_client_config" "current" {}




resource "azurerm_key_vault" "kv" {
  name                        = var.keyvault_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  enable_rbac_authorization   = true # we can do rbac or keyvault access policy. rbac if you want to use the role access = e.g. contributor no need to specify vault level permissions

  sku_name = "standard"

}
