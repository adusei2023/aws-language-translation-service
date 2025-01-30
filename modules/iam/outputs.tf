# Output the IAM Role ARN
output "lambda_role_arn" {
  description = "The ARN of the IAM role assigned to the Lambda function"
  value       = aws_iam_role.lambda_role.arn
}
