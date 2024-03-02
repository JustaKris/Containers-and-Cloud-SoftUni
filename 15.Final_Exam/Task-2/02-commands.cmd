::Download Azure.exe into current dir
terraform init

::Format and check validity of terraform files
terraform fmt
terraform validate

::Review what the file is going to do and then execute
az login
terraform plan -var-file=values.tfvars
terraform apply -var-file=values.tfvars

::Destroy everything
@REM terraform destroy -var-file=values.tfvars