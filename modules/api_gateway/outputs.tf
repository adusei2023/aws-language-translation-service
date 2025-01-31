# Output API Gateway ID
output "api_gateway_id" {
  description = "The ID of the API Gateway"
  value       = aws_api_gateway_rest_api.translate_api.id
}

# Output API Gateway Endpoint URL
output "api_gateway_url" {
  description = "The invoke URL of the API Gateway"
  value       = aws_api_gateway_deployment.translate_deployment.invoke_url
}
