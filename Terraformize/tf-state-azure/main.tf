provider "azurerm" {
  skip_provider_registration = true # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  features {}
}

module "storage_account" {
  source = "../tf-modules-templates/storage_accounts"

  # we can hard code an environment variable here coming from Azure DevOps
  storage_account_name      = "tfstateforkubernetes"
  resource_group_name       = "devops-demo-projects"
  location                  = "East US"
  account_tier              = "Standard"
  account_replication_type  = "LRS"
}


