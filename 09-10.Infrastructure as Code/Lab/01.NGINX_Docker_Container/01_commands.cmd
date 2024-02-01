echo off

::Check host name for terraform file
docker context ls

::Boot up terraform in current dir
terraform init

::Format and validate tf file
terraform fmt
terraform validate

::Test the tf file
terraform plan

::Run tf file
terraform apply

::Kill everything
terraform destroy