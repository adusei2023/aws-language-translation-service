output "requests_bucket_name" {
  value = module.s3.s3_requests_bucket
}

output "responses_bucket_name" {
  value = module.s3.s3_responses_bucket
}


output "lambda_function_name" {
  description = "Lambda function name"
  value       = module.lambda.lambda_function_name
}

output "api_gateway_url" {
  description = "Base URL for API Gateway"
  value       = module.api_gateway.api_gateway_url
}
