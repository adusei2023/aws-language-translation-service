# Output the ARN of the Lambda function
output "lambda_function_arn" {
  description = "The ARN of the created Lambda function"
  value       = aws_lambda_function.translate_function.arn
}

# Output the function name for reference
output "lambda_function_name" {
  description = "The name of the Lambda function"
  value       = aws_lambda_function.translate_function.function_name
}

# Output the function invocation ARN for API Gateway integration
output "lambda_function_invoke_arn" {
  description = "Invoke ARN of the Lambda function"
  value       = aws_lambda_function.translate_function.invoke_arn
}
