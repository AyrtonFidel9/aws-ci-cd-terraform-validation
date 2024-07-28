# CI/CD PIPELINE TO VALIDATE TERRAFORM

## Description
This repository is a Terraform project to validate each componente created using a CI/CD pipeline

#### Table of contents
1. [Diagram](#1-diagram-architecture)
2. [Requirements](#2-requirements)
3. [Techonoly Stack](#3-technology-stack)
4. [Directory Structure](#4-directory-structure)
5. [Variables](#5-variables)
6. [Terraform commands](#6-terraform-commands)

### 1. Diagram Architecture
![Pipeline diagram](/assets/cd-cd-terraform.png)
This CI/CD process was made to validate and deploy an infraestructure created using terraform, and contains a basic process to store a git repository, validate, plan, apply and destroy the infrastructure writed on terraform.


1. First, the process begin when a developer execute `git push` command in them local environment.
2. Second, all changes are store in a private git respository managed by AWS CodeCommit.
3. Third, the Valide stage created on AWS CODEBUILD uses the template `buildspec_apply.yml` to setup the environment install terraform an validating the terraform files to find syntax errors and format the files.
    - The source output is all files of the respository formated
4. Plan stage receives the ouput of Validate stage as input and using the template `buildspec_plan.yml` to prepare the environment installing terraform and executing `terraform plan` to consolidate and process the resources that will be deployed.
    - The source output is all files of the respository
5. Apply stage using the template `buildspec_apply.yml` installs terraform and execute `terraform apply` to implement all infrastructure. The input is the plan stage output
6. Destroy stage using the template `buildspec_destroy.yml` installs terraform and execute `terraform destroy` to delete all infrastructure
7. CodeBuild artifact results are stored in a S3 Bucket that is encrypted using a KMS key.

### 2. Requirements
Before use this script, user must achieve this requirements:
1. A terraform project to upload in the codecommit git repository
---
### 3. Technology stack
`buildspec.yml` and `appspec.yml` are constructed to support the following technologies:
1. Terraform
---


### 4. Directory Structure

```sh
.
├── envs
│   ├── backend.hcl
│   └── pipeline.tfvars
├── global
│   ├── dynamodb
│   ├── main.tf
│   ├── provider.tf
│   ├── s3
│   ├── terraform.tfstate
│   └── var.tfvars
├── main.tf
├── modules
│   ├── 01-kms-keys
│   ├── 02-iam
│   ├── 03-s3-bucket
│   ├── 04-code-commit
│   ├── 05-code-build
│   └── 06-codepipeline
├── provider.tf
├── readme.md
├── templates
│   ├── buildspec_apply.yml
│   ├── buildspec_destroy.yml
│   ├── buildspec_plan.yml
│   └── buildspec_validate.yml
└── variables.tf
```

- `envs` directory store the files used to configure and lunch configurations needed for the infrastructure.
- `global` directory contains resources that will be used in all infrastructure. For example, IAM user, rules and policies, S3 Bucket to store terraform states or DynamoDB table to store terraform locks
- `modules` contains the resources used to deploy the infraestructure and will be reutilized to create each component on the infrastructure.
  - `01-kms-keys` module contains standarized settings to provision kms key utilized to encrypt all ci/cd artifacts that will be store in a S3 bucket
  - `02-iam` module contains iam roles and permissions for each component and stage that is part of the ci/cd pipeline
  - `03-s3-bucket` module used to create a bucket that stores the ci/cd pipeline stage outputs 
  - `04-code-commit` module used to create a git repository to store the terraform project that will be validated for the ci/cd pipeline
  - `05-code-build` module used to create each stage that will be part of the pipeline.
  - `06-codepipeline` module used to integrate and orchestrate all stages that will validate the terraform project. 
- `templates` contains each buildspec file with the commands needed to configure the stage and execute the actions according with the porpouse of each stage.
- `variables.tf` file has the specification of each variable to configure the ci/cd pipeline
- `main.tf` file contains all modules implementations to create de ci/cd pipeline
- `provider.tf` file has the cloud provider that uses this repository project

### 5. Variables

Variables used to configure and deploy the pipeline are the following:

```bash
aws_region   = "us-east-1" # describe the region where the pipeline will be deployed 
aws_profile  = "my-profile" # describe the aws cli profile where access keys credentials are located
environment  = "dev" # describe the environment that will be belong the pipeline

# This variable contains the configuration of each CodeBuild stage that will belong to 
# the ci/cd pipeline
stages_input = [ 
  { 
    name = "validate",  # Stage name
    category = "Test", # Type of stage
    owner = "AWS", # Cloud or technology provider
    provider = "CodeBuild", # Type of service or techonology used to contruct the stage
    input_artifacts = "SourceOutput", # The origin where comes the files or artifacts that will be proccess by the stage
    output_artifacts = "ValidateOutput" # The location where the results generated by stage will be stored 
  },
  { 
    name = "plan", 
    category = "Test", 
    owner = "AWS", 
    provider = "CodeBuild", 
    input_artifacts = "ValidateOutput", 
    output_artifacts = "PlanOutput" 
  },
  { 
    name = "apply", 
    category = "Build", 
    owner = "AWS", 
    provider = "CodeBuild", 
    input_artifacts = "PlanOutput", 
    output_artifacts = "ApplyOutput" 
  },
  { 
    name = "destroy", 
    category = "Build", 
    owner = "AWS", 
    provider = "CodeBuild",
    input_artifacts = "ApplyOutput", 
    output_artifacts = "DestroyOutput" 
  }
]

# Variable to store the list of stages that will be created using CodeBuild module
build_projects = [ "validate", "plan", "apply", "destroy" ]

# Tags used to organize each component of the pipeline
created_by         = "Fidel Avalos Cuadrado"
application        = "terraform-cicd"
cost_center        = "ND"
contact            = "fidelito@mail.com"
maintenance_window = "ND"
deletion_date      = "ND"

```

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

Important in a next version IMPROVE VALIDATE STAGE WITH OTHER TOOLS