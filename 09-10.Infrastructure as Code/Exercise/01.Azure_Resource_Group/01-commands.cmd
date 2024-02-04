::Download Azure.exe into current dir
terraform init

::Check if .tf file is valid
terraform validate

::Review what the file is going to do and then execute
terraform plan
terraform apply

::Kill everything
terraform destroy