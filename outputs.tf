output "s3_bucket_name" {
  description = "Name of the S3 bucket created"
  value       = module.s3.bucket_name
}

output "lambda_function_name" {
  description = "Lambda function name"
  value       = module.lambda.lambda_name
}

output "api_gateway_url" {
  description = "Base URL for API Gateway"
  value       = module.api_gateway.api_gateway_url
}
