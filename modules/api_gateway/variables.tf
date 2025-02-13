# Project Tags
variable "tags" {
  description = "Additional tags for the resource"
  type        = map(string)
}

# Project Name
variable "project" {
  description = "Project name"
  type        = string
  default     = "aws-lambda-translate"
}

# Deployment Environment
variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

# AWS Region
variable "region" {
  description = "AWS region to deploy the resources"
  type        = string
}

# Lambda Function ARN (For API Gateway Integration)
variable "lambda_function_invoke_arn" {
  description = "ARN of the Lambda function to invoke"
  type        = string
}

# Lambda Function Name (For Permission Attachment)
variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
}

# KMS Key ID for Encryption
variable "kms_key_id" {
  description = "The KMS key ID to use for encrypting CloudWatch logs"
  type        = string
}
