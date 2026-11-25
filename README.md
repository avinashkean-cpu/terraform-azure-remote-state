# Azure Terraform Remote State

This Terraform project creates the Azure resources used to store Terraform state in an Azure Blob container. The AzureRM backend stores state remotely and uses blob leases for state locking.

## Resources

- Azure Resource Group
- Azure Storage Account (Standard, locally redundant storage)
- Private Blob container for Terraform state

Resource names and the deployment region are defined in the Terraform files.

## Prerequisites

- Terraform CLI
- Azure CLI
- An Azure subscription with permission to create the resources
- `Storage Blob Data Contributor` access for the signed-in Azure user on the state container

## Select the Azure subscription

```powershell
az login
az account set --subscription "<SUBSCRIPTION_ID>"
az account show --query "{user:user.name, subscription:name, id:id}" -o table
```

Use a region allowed for the subscription. Azure may reject deployments in regions that are not available to the subscription.

## First-time bootstrap

The backend storage account and container must exist before Terraform can initialize the Azure backend. For a new deployment:

1. Temporarily omit the `backend "azurerm"` block while keeping the provider and resource definitions.
2. Create the resource group, storage account, and private state container using local state:

   ```powershell
   terraform init
   terraform plan
   terraform apply
   ```

3. Add the AzureRM backend block to the existing `terraform` block. Configure it with the storage account name, container name, and state blob key. For Azure CLI authentication, use `use_cli = true` and `use_azuread_auth = true`.
4. Migrate the local state to Azure Storage:

   ```powershell
   terraform init -migrate-state
   ```

5. Confirm the migration when Terraform prompts you.

The signed-in Azure user needs the `Storage Blob Data Contributor` role on the state container to list and read/write blobs. If you have just assigned the role, allow time for it to take effect before retrying.

## Normal workflow

After the remote backend is initialized, run:

```powershell
terraform init
terraform plan
terraform apply
```

List resources recorded in the active state with:

```powershell
terraform state list
```

## Protect state and credentials

Terraform state may contain sensitive values. Do not commit state files, state backups, `.terraform/`, plan files, or secret `.tfvars` files. The `.gitignore` file excludes these local files. Commit `.terraform.lock.hcl` to keep provider versions consistent.

Do not store Azure passwords, Storage Account keys, SAS tokens, or client secrets in Terraform files or Git.
