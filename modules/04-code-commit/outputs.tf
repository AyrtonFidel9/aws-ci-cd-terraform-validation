output "repository_id" {
  description = "CodeCommit repository ID"
  value = aws_codecommit_repository.tf_infrastructure_repository.id
}

output "repository_branch" {
  value = aws_codecommit_repository.tf_infrastructure_repository.default_branch
}