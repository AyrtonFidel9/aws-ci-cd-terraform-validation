output "s3bucket_arn" {
  value = aws_s3_bucket.codepipeline-bucket-s3.arn
  description = "Codepipeline S3 BUCKET ARN"
}

output "s3bucket_name" {
  value = aws_s3_bucket.codepipeline-bucket-s3.bucket
  description = "Codepipeline S3 BUCKET NAME"
}

output "s3bucket_key_arn" {
  value = aws_s3_bucket.codepipeline-bucket-s3.arn
  description = "Codepipeline S3 BUCKET KEY ARN"
}

