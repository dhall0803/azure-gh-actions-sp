output "client_id" {
  description = "The client ID of the Azure AD application"
  value       = azuread_application.app.client_id
}

output "application_id" {
  description = "The ID of the Azure AD application registration"
  value       = azuread_application.app.id
}

output "service_principal_object_id" {
  description = "The object ID of the service principal"
  value       = azuread_service_principal.sp.object_id
}