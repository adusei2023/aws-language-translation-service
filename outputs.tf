# ===========================
#   Terraform Outputs
# ===========================

# Output the name of the translation request bucket
output "translation_request_bucket_name" {
  description = "Name of the S3 bucket storing translation requests"
  value       = module.translation_request_bucket.bucket_name
}

# Output the name of the translation response bucket
output "translation_response_bucket_name" {
  description = "Name of the S3 bucket storing translation responses"
  value       = module.translation_response_bucket.bucket_name
}

# Output the deployed Lambda function name
output "translation_lambda_function_name" {
  description = "Name of the deployed AWS Lambda function"
  value       = module.translation_lambda.function_name
}

# Output the API Gateway base URL
output "translation_api_gateway_url" {
  description = "Base URL for the API Gateway endpoint"
  value       = module.translation_api_gateway.api_gateway_endpoint
}
