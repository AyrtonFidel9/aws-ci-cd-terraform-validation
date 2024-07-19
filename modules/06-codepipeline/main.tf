resource "aws_codepipeline" "terraform_codepipeline" {
  name = "${var.tags.Application}-${var.tags.Environment}-pipeline"
  role_arn        = var.iam_codepipeline_arn
  execution_mode  = var.execution_mode
  pipeline_type   = var.version_pipeline

  artifact_store {
    location = var.s3_bucket_codepipeline
    type = "S3"
    encryption_key {
      id   = var.kms_arn_s3_bucket
      type = "KMS"
    }
  }   

  stage {
    name = "Source"
    action {
      name              = "SourceCodeCommitInit"
      category          = "Source"
      owner             = "AWS"
      provider          = "CodeCommit"
      version           = "1"
      output_artifacts  = [ "SourceOutput" ]
      run_order         = 1

      configuration = {
        RepositoryName        = var.aws_codecommit_repo_id
        BranchName            = var.aws_codecommit_repo_branch
        PollForSourceChanges  = "false"
      }
    }
  }

  dynamic "stage" {
    for_each = var.stages

    content {
      name = "Stage-${stage.value["name"]}"
      action {
        category         = stage.value["category"]
        name             = "Action-${stage.value["name"]}"
        owner            = stage.value["owner"]
        provider         = stage.value["provider"]
        input_artifacts  = [stage.value["input_artifacts"]]
        output_artifacts = [stage.value["output_artifacts"]]
        version          = "1"
        run_order        = index(var.stages, stage.value) + 2
        configuration = {
          ProjectName = stage.value["provider"] == "CodeBuild" ? "${var.tags.Application}-${stage.value["name"]}" : null
        }
      }
    }
  }

  tags = tomap((var.tags))
}