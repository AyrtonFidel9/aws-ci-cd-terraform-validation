resource "aws_codecommit_repository" "tf_infrastructure_repository" {
  repository_name = var.repository_name
  default_branch  = var.branch_default_name
  description     = var.description
}