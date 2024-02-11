echo off

az login

az ad sp create-for-rbac --name "Azure-Terraform-Kris-SP" --role contributor --scope /subscriptions/8cc3b19d-7561-48c8-a766-88e342d09a6a --sdk-auth

@REM Output JSON
@REM {
@REM   "clientId": "366be79c-0296-4b50-b408-c930dcde5aa6",
@REM   "clientSecret": "mys8Q~nyPufWAF3kof-.EwV4aQkzQAaogRTrQa3l",
@REM   "subscriptionId": "8cc3b19d-7561-48c8-a766-88e342d09a6a",
@REM   "tenantId": "4a06d40c-e447-42be-baef-dd0421ed10bd",
@REM   "activeDirectoryEndpointUrl": "https://login.microsoftonline.com",
@REM   "resourceManagerEndpointUrl": "https://management.azure.com/",
@REM   "activeDirectoryGraphResourceId": "https://graph.windows.net/",
@REM   "sqlManagementEndpointUrl": "https://management.core.windows.net:8443/",
@REM   "galleryEndpointUrl": "https://gallery.azure.com/",
@REM   "managementEndpointUrl": "https://management.core.windows.net/"
@REM }

::Setup Azure storage account in a storage resource group
az storage account create --name taskboardstoragekris --resource-group StorageRG --location westeurope --sku Standard_LRS --kind StorageV2

::Setup a container inside storage account. Acts as a folder.
az storage container create -n taskboardcontainer --account-name taskboardstoragekris