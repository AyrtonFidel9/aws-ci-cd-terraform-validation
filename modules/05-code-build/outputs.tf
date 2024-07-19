output "name" {
  value       = aws_codebuild_project.terraform_codebuild_project[*].name
  description = "List of Names of the CodeBuild projects"
}