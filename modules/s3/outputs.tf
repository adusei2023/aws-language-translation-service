# Output the name of the translation requests bucket
output "s3_requests_bucket" {
  description = "Name of the translation requests S3 bucket"
  value       = aws_s3_bucket.requests_bucket.id
}

# Output the name of the translation responses bucket
output "s3_responses_bucket" {
  description = "Name of the translation responses S3 bucket"
  value       = aws_s3_bucket.responses_bucket.id
}

# Output the ARN of the translation requests bucket
output "s3_requests_bucket_arn" {
  description = "ARN of the translation requests S3 bucket"
  value       = aws_s3_bucket.requests_bucket.arn
}

# Output the ARN of the translation responses bucket
output "s3_responses_bucket_arn" {
  description = "ARN of the translation responses S3 bucket"
  value       = aws_s3_bucket.responses_bucket.arn
}