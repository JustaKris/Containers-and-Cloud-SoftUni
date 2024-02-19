::Download Azure.exe into current dir
terraform init

::Check if .tf file is valid
terraform fmt
terraform validate

::Review what the file is going to do and then execute
az login
terraform plan -var-file=values.tfvars
terraform apply -var-file=values.tfvars

::Kill everything
terraform destroy -var-file=values.tfvars