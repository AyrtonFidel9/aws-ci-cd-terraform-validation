resource "aws_codebuild_project" "terraform_codebuild_project" {

  count = length(var.build_projects)

  name            = "${var.tags.Application}-${var.build_projects[count.index]}"
  service_role    = var.codebuild_service_roles_arn[count.index]
  encryption_key  = var.encryption_key_arn

  artifacts {
    type                = var.build_project_source
    location            = var.s3_bucket_codepipeline
    packaging           = "ZIP"
  }

  environment {
    compute_type                    = var.builder_compute_type
    image                           = var.builder_image
    type                            = var.builder_type
    privileged_mode                 = true
    image_pull_credentials_type     = var.builder_image_pull_credentials_type 
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }
  }

  source {
    type = var.build_project_source
     buildspec = "./templates/buildspec_${var.build_projects[count.index]}.yml"
  }

  tags = tomap(var.tags)
}