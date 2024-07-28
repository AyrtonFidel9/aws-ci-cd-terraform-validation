terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.55.0"
    }
  }
  backend "s3" {
    
  }
}

module "kms_keys" {
  source = "./modules/01-kms-keys"
  codepipeline_role_arn = module.iam_permissions.iam_role_cp_arn
  tags = {
    Name                = "kms-key/codepipeline-${var.application}-${var.environment}"
    Description         = "This key is used to encrypt bucket objects"
    Environment         = var.environment
    CreatedBy           = var.created_by
    Application         = var.application
    CostCenter          = var.cost_center
    Contact             = var.contact
    MaintenanceWindow   = var.maintenance_window
    DeletionDate        = var.deletion_date
  }
}

module "s3_bucket" {
  source = "./modules/03-s3-bucket"
  kms_key_arn = module.kms_keys.arn

  tags = {
    Name                = "codepipeline-${var.application}-${var.environment}-bucket"
    Description         = "This key is used to encrypt bucket objects."
    Environment         = var.environment
    CreatedBy           = var.created_by
    Application         = var.application
    CostCenter          = var.cost_center
    Contact             = var.contact
    MaintenanceWindow   = var.maintenance_window
    DeletionDate        = var.deletion_date
  }
}

module "iam_permissions" {
  source = "./modules/02-iam"

  bucket_codepipeline_name  = module.s3_bucket.s3bucket_name
  codebuild_name            = var.build_projects
  codepipeline_name         = "${var.application}-${var.environment}-pipeline"
  kms_arn                   = module.kms_keys.arn

  tags = {
    Environment         = var.environment
    CreatedBy           = var.created_by
    Application         = var.application
    CostCenter          = var.cost_center
    Contact             = var.contact
    MaintenanceWindow   = var.maintenance_window
    DeletionDate        = var.deletion_date
  }
}

module "repository" {
  source = "./modules/04-code-commit"

  repository_name     = "ci-cd-terraform-repository"
  branch_default_name = "main"
  description         = "ci-cd repository for terraform"
}

module "codebuild" {
  source = "./modules/05-code-build"

  build_projects              = var.build_projects
  build_project_source        = var.build_project_source
  codebuild_service_roles_arn  = module.iam_permissions.iam_roles_codebuild_arn
  builder_compute_type        = var.builder_compute_type
  builder_type                = var.builder_type
  builder_image               = var.builder_image
  encryption_key_arn          = module.kms_keys.arn
  s3_bucket_codepipeline      = module.s3_bucket.s3bucket_name
  builder_image_pull_credentials_type = var.builder_image_pull_credentials_type
  
  tags = {
    Environment         = var.environment
    CreatedBy           = var.created_by
    Application         = var.application
    CostCenter          = var.cost_center
    Contact             = var.contact
    MaintenanceWindow   = var.maintenance_window
    DeletionDate        = var.deletion_date
  }
}

module "codepipeline_terraform" {
  source = "./modules/06-codepipeline"

  stages                        = var.stages_input
  aws_codecommit_repo_id        = module.repository.repository_id
  aws_codecommit_repo_branch    = module.repository.repository_branch
  execution_mode                = var.execution_mode
  kms_arn_s3_bucket             = module.kms_keys.arn
  iam_codepipeline_arn          = module.iam_permissions.iam_role_cp_arn
  s3_bucket_codepipeline        = module.s3_bucket.s3bucket_name
  version_pipeline              = var.version_pipeline

  tags = {
    Name                = "${var.application}-${var.environment}-pipeline"
    Description         = "Codedeploy project to configure and install application in a compute server"
    Environment         = var.environment
    CreatedBy           = var.created_by
    Application         = var.application
    CostCenter          = var.cost_center
    Contact             = var.contact
    MaintenanceWindow   = var.maintenance_window
    DeletionDate        = var.deletion_date
  }

}