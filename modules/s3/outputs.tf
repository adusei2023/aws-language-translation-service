# Output the name of the translation requests bucket
output "requests_bucket_name" {
  description = "Name of the translation requests S3 bucket"
  value       = aws_s3_bucket.requests_bucket.id
}

# Output the name of the translation responses bucket
output "responses_bucket_name" {
  description = "Name of the translation responses S3 bucket"
  value       = aws_s3_bucket.responses_bucket.id
}
