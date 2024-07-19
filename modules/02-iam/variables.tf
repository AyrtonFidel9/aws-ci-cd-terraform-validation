variable "codepipeline_name" {
  description = "Codepipeline name"
  type = string
}

variable "codebuild_name" {
  description = "CodeBuild name"
  type = list(string)
}

variable "bucket_codepipeline_name" {
  description = "Name of the codepipeline s3 bucket"
  type = string
}

variable "kms_arn" {
  description = "KMS key arn"
  type = string
}

variable "tags" {
  description = "Tags to be associated with the S3 bucket"
  type        = map
}