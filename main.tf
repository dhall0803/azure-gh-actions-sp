
resource "azurerm_ad_application" "app" {
	display_name = var.application_registration_name
}

resource "azurerm_ad_service_principal" "sp" {
	application_id = azurerm_ad_application.app.application_id
}

resource "azurerm_role_assignment" "storage_blob_data_owner" {
	scope                = var.terraform_state_storage_storage_account_id
	role_definition_name = "Storage Blob Data Owner"
	principal_id         = azurerm_ad_service_principal.sp.id
}

resource "azurerm_role_assignment" "subscription_owner" {
	scope                = "/subscriptions/${var.deployment_subscription_id}"
	role_definition_name = "Owner"
	principal_id         = azurerm_ad_service_principal.sp.id
}

resource "azurerm_ad_federated_identity_credential" "github_actions" {
  application_object_id = azurerm_ad_application.app.id
  name                  = "GitHubActionsCredential"
  issuer                = "https://token.actions.githubusercontent.com"
  subject               = "repo:${var.github_username}/${var.github_repository_name}:ref:refs/heads/${var.gihub_branch_name}"
  audiences             = ["api://AzureADTokenExchange"]
}
