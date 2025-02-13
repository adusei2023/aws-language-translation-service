# Output API Gateway ID
output "api_gateway_id" {
  description = "The ID of the API Gateway"
  value       = aws_apigatewayv2_api.api_gateway.id
}

# Output API Gateway Endpoint URL
output "api_gateway_endpoint" {
  description = "Base URL for the API Gateway"
  value       = aws_apigatewayv2_stage.api_stage.invoke_url
}
