output "iam_role_cp_arn" {
  value = aws_iam_role.codepipeline-basic-role.arn
}

output "iam_roles_codebuild_arn" {
  value = aws_iam_role.codebuild-service-role[*].arn
}
