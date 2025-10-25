variable "application_registration_name" {
  description = "Display name for the Azure AD application registration and service principal"
  type        = string
}

variable "terraform_state_storage_storage_account_id" {
  description = <<-EOT
The storage account resource id (full resource id) that will be the scope for the
"Storage Blob Data Owner" role assignment. Example:
`/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-name/providers/Microsoft.Storage/storageAccounts/storageacctname`
EOT
  type = string
}

variable "deployment_subscription_id" {
  description = "Subscription id where the 'Owner' role assignment will be scoped"
  type        = string
}

variable "github_username" {
  description = "GitHub username, used to build Subject Identifier for federated identity credential"
  type        = string
}

variable "github_repository_name" {
  description = "GitHub repository name, used to build Subject Identifier for federated identity credential"
  type        = string
}

variable "gihub_branch_name" {
  description = "GitHub branch name, used to build Subject Identifier for federated identity credential"
  type        = string
  default = "main"
}

