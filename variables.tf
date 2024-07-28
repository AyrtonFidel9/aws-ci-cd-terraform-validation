variable "aws_region" {}
variable "aws_profile" {}

variable "build_projects" {
  description = "Build projects names to make the pipeline"
  type = list(string)
}

variable "build_project_source" {
  type        = string
  default     = "CODEPIPELINE"
}

variable "builder_type" {
  description = "Type of codebuild run environment"
  type        = string
  default     = "LINUX_CONTAINER"
}

variable "builder_compute_type" {
  description = "Relative path to the Apply and Destroy build spec file"
  type        = string
  default     = "BUILD_GENERAL1_SMALL"
}

variable "builder_image" {
  description = "Docker Image to be used by codebuild"
  type        = string
  default     = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
}

variable "builder_image_pull_credentials_type" {
  description = "Image pull credentials type used by codebuild project"
  type        = string
  default     = "CODEBUILD"
}

variable "stages_input" {
  description = "Tags to be attached to the CodePipeline"
  type        = list(map(any))
}


variable "execution_mode" {
  description = "execution mode type for codepipeline"
  default = "QUEUED"
}

variable "version_pipeline" {
  description = "version type for codepipeline"
  default = "V2"
}


# Variable Tags
variable "environment" {
  description = "Describe the kind of environment in that the resources will be used (dev|uat|prod)"
}

variable "created_by" {
  description = "Person who created the resource"
}

variable "application" {
  description = "The service or application of which the resource is a component"
}

variable "cost_center" {
  description = "Useful for billing center (Human Resources | IT department)"
}

variable "contact" {
  description = "email address for the team or individual"
}

variable "maintenance_window" {
  description = "Useful for defining a window of time that resource is allows to not be available in case of parching, updates, or maintance"
}

variable "deletion_date" {
  description = "Useful for development or sandbox environments so that you know when it may be safe to delete a resource"
}
