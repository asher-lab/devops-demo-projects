# Output the storage account id
output "storage_account_id" {
  value = module.storage_account.storage_account_id
  sensitive = true
}