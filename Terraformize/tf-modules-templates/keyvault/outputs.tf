output "keyvault_id" {
    value = azurerm_key_vault.kv.id
} 

# use this output variable inside the root module, this acts as an input to the root module