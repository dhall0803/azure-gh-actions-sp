
resource "azuread_application" "app" {
  display_name = var.application_registration_name
  owners       = var.owner_object_ids
}

resource "azuread_service_principal" "sp" {
  client_id = azuread_application.app.client_id
}

resource "azurerm_role_assignment" "storage_blob_data_owner" {
  scope                = var.terraform_state_storage_storage_account_id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azuread_service_principal.sp.object_id
}

resource "azurerm_role_assignment" "subscription_owner" {
  scope                = "/subscriptions/${var.deployment_subscription_id}"
  role_definition_name = "Owner"
  principal_id         = azuread_service_principal.sp.object_id
}

resource "azurerm_role_assignment" "additional_roles" {
  for_each = var.additional_roles_to_assign

  scope                = each.value.scope
  role_definition_name = each.value.role_definition_name
  principal_id         = azuread_service_principal.sp.object_id
}

resource "azuread_application_federated_identity_credential" "github_actions" {
  application_id = azuread_application.app.id
  display_name   = "GitHubActionsCredential"
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = "repo:${var.github_username}/${var.github_repository_name}:ref:refs/heads/${var.gihub_branch_name}"
  audiences      = ["api://AzureADTokenExchange"]
}
