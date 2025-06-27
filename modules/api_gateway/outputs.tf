# Get current AWS region
data "aws_region" "current" {}

# Output the API Gateway ID
output "api_gateway_id" {
  description = "The ID of the API Gateway"
  value       = aws_api_gateway_rest_api.main.id
}

# Output the API Gateway endpoint URL using current region
output "api_gateway_endpoint" {
  description = "The invoke URL of the API Gateway stage"
  value       = "https://${aws_api_gateway_rest_api.main.id}.execute-api.${data.aws_region.current.id}.amazonaws.com/${aws_api_gateway_stage.main.stage_name}"
}

# Output the API Gateway execution ARN
output "api_gateway_execution_arn" {
  description = "The execution ARN of the API Gateway"
  value       = aws_api_gateway_rest_api.main.execution_arn
}

# Output the API Gateway stage name
output "stage_name" {
  description = "The name of the API Gateway stage"
  value       = aws_api_gateway_stage.main.stage_name
}
