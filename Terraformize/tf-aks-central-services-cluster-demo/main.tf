provider "azurerm" {
  skip_provider_registration = true # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  features {}
  # client_id     = 
  # subscription_id = 
  # tenant_id       = 
}

module "resource_group" {
  source = "../tf-modules-templates/resource-group"

  # Variables
  rg_name =  var.rg_name
  rg_location = var.rg_location

  # tags
  rg_tags = var.rg_tags
}

module "service-principal" {
  source = "../tf-modules-templates/service-principal"

  depends_on = [module.resource_group]

  # Variables
  service_principal_name = var.service_principal_name
}

# Create a role for the app registration, service specific
# No need for creating a module since it cannot work on any other places

# assig contributor role to service principal
resource "azurerm_role_assignment" "spn" {
  #scope                = data.azurerm_subscription.primary.id
  scope                 = "/subscriptions/91083691-9392-4c90-ada2-a63f7e61dbb9"
  role_definition_name = "Contributor" # so this can create AKS and has get access to KeyVault 
  principal_id         = module.service-principal.service_principal_object_id
  depends_on = [ module.service-principal ]
}

# this becomes a redundancy
resource "azurerm_role_assignment" "spn-keyvault" {
  #scope                = data.azurerm_subscription.primary.id
  scope                 = module.keyvault.keyvault_id
  role_definition_name = "Key Vault Administrator" # so this can create AKS and has get access to KeyVault 
  principal_id         = module.service-principal.service_principal_object_id
  depends_on = [ module.keyvault]
}

# this becomes a redundancy
# my primary principal

resource "azurerm_role_assignment" "spn-keyvault-principal" {
  scope                 = data.azurerm_subscription.primary.id
  role_definition_name = "Key Vault Administrator" # so this can create AKS and has get access to KeyVault 
  principal_id         =  data.azurerm_client_config.current.object_id
  depends_on = [ module.keyvault]
}


module "keyvault" {
  source = "../tf-modules-templates/keyvault"
  keyvault_name               = var.keyvault_name
  location                    = var.rg_location
  resource_group_name         = var.rg_name
  service_principal_name      = var.service_principal_name
  service_principal_object_id = module.service-principal.service_principal_object_id
  service_principal_tenant_id = module.service-principal.service_principal_tenant_id

  depends_on = [
    module.service-principal
  ]
}


#Store the value of SP id and secret in KeyVault
resource "azurerm_key_vault_secret" "kv" {
  name         = module.service-principal.client_id
  value        = module.service-principal.client_secret
  key_vault_id = module.keyvault.keyvault_id

  depends_on = [ module.keyvault,  azurerm_role_assignment.spn-keyvault-principal ]
}


# AKS
#create Azure Kubernetes Service
module "aks" {
  source                 = "../tf-modules-templates/aks"
  service_principal_name = var.service_principal_name
  client_id              = module.service-principal.client_id
  client_secret          = module.service-principal.client_secret
  location               = var.rg_location
  resource_group_name    = var.rg_name

  depends_on = [
    module.service-principal,
   
  ]

}

# resource "local_file" "kubeconfig" {
#   depends_on   = [module.aks]
#   filename     = "./kubeconfig"
#   content      = module.aks.config
  
# }