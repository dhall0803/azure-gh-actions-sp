# Azure Terraform Service Principal Module

This Terraform module creates an Azure Active Directory (Azure AD) application registration and service principal with the necessary permissions for GitHub Actions to deploy Azure resources using Terraform. It assumes that a storage account is being used for state management and assigns the Storage Blob Data Owner role to the created service principal.

## Purpose

This module sets up the identity and access management foundation for GitHub Actions workflows that need to deploy Azure infrastructure using Terraform. It creates a service principal with federated identity credentials for passwordless authentication from GitHub Actions.

## Capabilities

### Resources Created

- **Azure AD Application**: An application registration that serves as the identity foundation
- **Service Principal**: A service principal associated with the application for authentication
- **Role Assignments**: 
  - `Storage Blob Data Owner` on the specified storage account (for Terraform state management)
  - `Owner` at the subscription level (for resource deployment)
- **Federated Identity Credential**: Enables GitHub Actions to authenticate without storing secrets

### Features

- **Passwordless Authentication**: Uses OpenID Connect (OIDC) federated identity credentials instead of client secrets
- **Least Privilege Access**: Grants specific permissions only where needed
- **GitHub Actions Integration**: Pre-configured for seamless GitHub Actions workflow authentication
- **Terraform State Management**: Includes permissions for accessing Terraform remote state storage
- **Flexible Role Assignment**: Supports additional custom role assignments beyond the default ones
- **Application Ownership**: Configurable ownership of the Azure AD application registration

## Usage

```hcl
module "terraform_service_principal" {
  source = "./path/to/this/module"

  application_registration_name              = "my-terraform-sp"
  terraform_state_storage_storage_account_id = "/subscriptions/sub-id/resourceGroups/rg/providers/Microsoft.Storage/storageAccounts/mystorageaccount"
  deployment_subscription_id                 = "your-subscription-id"
  github_username                           = "your-github-username"
  github_repository_name                    = "your-repo-name"
  gihub_branch_name                         = "main"
  owner_object_ids                          = ["00000000-0000-0000-0000-000000000000"]  # Optional
  
  # Optional: Additional role assignments
  additional_roles_to_assign = {
    "custom-role" = {
      scope                = "/subscriptions/your-subscription-id/resourceGroups/your-rg"
      role_definition_name = "Contributor"
    }
  }
}
```

## Input Variables

| Variable | Description | Type | Default | Required |
|----------|-------------|------|---------|----------|
| `application_registration_name` | Display name for the Azure AD application registration and service principal | `string` | - | Yes |
| `terraform_state_storage_storage_account_id` | The storage account resource ID for "Storage Blob Data Owner" role assignment | `string` | - | Yes |
| `deployment_subscription_id` | Subscription ID where the 'Owner' role assignment will be scoped | `string` | - | Yes |
| `github_username` | GitHub username for federated identity credential | `string` | - | Yes |
| `github_repository_name` | GitHub repository name for federated identity credential | `string` | - | Yes |
| `gihub_branch_name` | GitHub branch name for federated identity credential | `string` | `"main"` | No |
| `owner_object_ids` | List of Azure AD Object IDs to assign as owners of the application | `list(string)` | `[]` | No |
| `additional_roles_to_assign` | Map of additional roles to assign to the service principal | `map(object)` | `{}` | No |

## Outputs

- `client_id`: The client ID of the Azure AD application (used for authentication)
- `application_id`: The ID of the Azure AD application registration (internal identifier)
- `service_principal_object_id`: The object ID of the service principal

## Requirements

- Terraform >= 1.1.0
- Azure provider (~> 4.0)
- Azure AD provider (~> 3.0)
- Appropriate Azure permissions to create applications and service principals

## Security Considerations

This module creates a service principal with Owner permissions at the subscription level. Ensure this aligns with your security requirements and consider using more restrictive roles if possible for your specific use case.