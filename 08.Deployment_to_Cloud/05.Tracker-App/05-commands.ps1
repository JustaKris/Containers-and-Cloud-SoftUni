# Install Azure CLI
$ProgressPreference = 'SilentlyContinue'; `
Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; `
Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; `
rm .\AzureCLI.msi

# Build and run the provided dockerfile
docker build -t tracker-app-image .
docker run -d --rm --name tracker-app -p 80:80 tracker-app-image

# Now to log into Azure and start using the CLI
az login
az group create --name trackerapprg --location westeurope  # Create resource group
az acr create -g trackerapprg --name trackerappcrkrisb --sku Basic  # Create container registry (requires unique name)
az acr show --name trackerappcrkrisb --query loginServer --output table  # Check loginServer
docker tag tracker-app-image trackerappcrkrisb.azurecr.io/tracker-app-image:v1  #Rename container to match provided login server

# Now to push the image to Docker Hub
az acr login --name trackerappcrkrisb  # First have to login to the container registry
az acr show --name trackerappcrkrisb  # Show container registry info
docker push trackerappcrkrisb.azurecr.io/tracker-app-image:v1  # Push image to Docker Hub

# Now to deploy the container application I need to set up some variables to keep all the credential I will require
$ACR_NAME='trackerappcrkrisb'
$SERVICE_PRINCIPAL_NAME='trackerappcrkrisbsp'

# Obtain the full registry ID 
$ACR_REGISTRY_ID = $(az acr show `
  --name $ACR_NAME `
  --query "id" `
  --output tsv)

# Create and configure the service principal with pull permissions to registry 
$PASSWORD = $(az ad sp create-for-rbac `
  --name $SERVICE_PRINCIPAL_NAME `
  --scopes $ACR_REGISTRY_ID `
  --role acrpull `
  --query "password" `
  --output tsv)

$USER_NAME = $(az ad sp list `
  --display-name $SERVICE_PRINCIPAL_NAME `
  --query "[].appId" `
  --output tsv)

# Output the service principal's credentials
Write-Output "Service principal ID: $USER_NAME"
Write-Output "Service principal password: $PASSWORD"

# Deploy container
az container create `
  --resource-group trackerapprg `
  --name tracker-app `
  --image trackerappcrkrisb.azurecr.io/tracker-app-image:v1 `
  --cpu 1 `
  --memory 1 `
  --registry-login-server trackerappcrkrisb.azurecr.io `
  --registry-username $USER_NAME `
  --registry-password $PASSWORD `
  --ip-address Public `
  --dns-name-label krisbtracker `
  --ports 80

# Check container domain
az container show -g trackerapprg --name tracker-app --query ipAddress.fqdn