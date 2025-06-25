# Output the name of the S3 bucket where translation requests are stored
output "request_bucket_name" {
  description = "The name of the S3 bucket that stores incoming translation requests before processing"
  value       = module.request_bucket.bucket_name
}

# Output the name of the S3 bucket where translation responses and logs are stored
output "response_bucket_name" {
  description = "The name of the S3 bucket that stores completed translation results and processing logs"
  value       = module.response_bucket.bucket_name
}

# Output the name of the deployed AWS Lambda function
output "lambda_function_name" {
  description = "The name of the AWS Lambda function that handles text translation operations using Amazon Translate"
  value       = module.lambda.function_name
}

# Output the API Gateway endpoint URL for making translation requests
output "api_gateway_url" {
  description = "The public endpoint URL of the API Gateway that clients can use to submit translation requests"
  value       = module.api_gateway.api_gateway_endpoint
}