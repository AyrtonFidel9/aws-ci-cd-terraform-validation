variable "iam_codepipeline_arn" {
  description = "codepipeline iam service role arn"
  type = string
}

variable "s3_bucket_codepipeline" {
  description = "codepipeline s3 bucket"
  type = string
}

variable "kms_arn_s3_bucket" {
  description = "kms key used on s3 bucket"
  type = string
}

variable "aws_codecommit_repo_id"{
  description = "codecommit repository name"
  type = string
}

variable "aws_codecommit_repo_branch"{
  description = "codecommit repository branch"
  type = string
}

variable "execution_mode" {
  description = "codepipeline execution mode"
  type = string
}

variable "version_pipeline" {
  description = "codepipeline version"
  type = string
}

variable "stages" {
  
}

variable "tags" {
  description = "Tags to be associated with the S3 bucket"
  type        = map
}

