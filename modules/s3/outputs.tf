# Output the S3 bucket name
output "s3_translation_bucket_name" {
  description = "Name of the S3 translation bucket"
  value       = aws_s3_bucket.translation_bucket.id
}

# Output the S3 bucket ARN
output "s3_translation_bucket_arn" {
  description = "ARN of the S3 translation bucket"
  value       = aws_s3_bucket.translation_bucket.arn
}
