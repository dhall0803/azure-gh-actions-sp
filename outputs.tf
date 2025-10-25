output "application_id" {
  description = "The client (application) id of the created Azure AD application"
  value       = azurerm_ad_application.app.application_id
}

output "service_principal_object_id" {
  description = "The object id of the created service principal"
  value       = azurerm_ad_service_principal.sp.id
}
