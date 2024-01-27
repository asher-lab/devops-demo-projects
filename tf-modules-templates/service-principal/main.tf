
# fetch data from the provider, no need to do anything
data "azuread_client_config" "current" {}


# We need to create an application first
resource "azuread_application" "spn" {
  display_name = var.service_principal_name
  owners       = [data.azuread_client_config.current.object_id]
}

# Then we will create a service principal. Application is needed before having an SP
# This SP is used to provision an AKS
# We can add a contributor role here
resource "azuread_service_principal" "spn" {
  client_id                    = azuread_application.spn.client_id
  app_role_assignment_required = true
  owners                       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal_password" "spn" {
  service_principal_id = azuread_service_principal.spn.object_id
}

# For here we want to output the value into keyvault, we use output variables