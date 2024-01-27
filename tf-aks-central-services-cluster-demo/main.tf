provider "azurerm" {
  skip_provider_registration = true # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  features {}
}

module "resource_group" {
  source = "../tf-modules-templates/resource-group"

  # Variables
  rg_name =  var.rg_name
  rg_location = var.rg_location

  # tags
  rg_tags = {
    Environment = "development"
    Department  = "devops-group"
    Owner       = "Asher"
    // Add more tags as needed
  }
}

module "service-principal" {
  source = "../tf-modules-templates/service-principal"

  depends_on = [module.resource_group]

  
  # Variables
  service_principal_name = var.service_principal_name
}
