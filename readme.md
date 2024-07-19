### 6. Terraform commands
```bash
# prepare dependencies and reference to remote backend
terraform init -backend-config=envs/backend-dev.hcl
# reconfigure dependencies
terraform init -backend-config=envs/backend-dev.hcl -reconfigure
# prepare resources to deploy 
terraform plan -var-file=envs/dev.tfvars
# deploy resources to aws
terraform apply -var-file=envs/dev.tfvars
# destroy resources
terraform destroy -var-file=envs/uat.tfvars
# destroy resources that belongs a specific module
terraform destroy -var-file=envs/uat.tfvars -target=module.vpc
```

