# Install Azure CLI
$ProgressPreference = 'SilentlyContinue'; `
Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; `
Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; `
rm .\AzureCLI.msi
