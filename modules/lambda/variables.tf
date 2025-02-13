# Name of the Lambda function
variable "function_name" {
  description = "The name of the Lambda function"
  type        = string
}

# Lambda handler function inside the Python script (e.g., lambda_translate.lambda_handler)
variable "function_handler" {
  description = "The name of the function handler (e.g., lambda_translate.lambda_handler)"
  type        = string
}

# S3 bucket for storing translation requests
variable "request_bucket" {
  description = "The name of the S3 bucket where translation requests are stored"
  type        = string
}

# S3 bucket for storing translation responses
variable "response_bucket" {
  description = "The name of the S3 bucket where translation responses are stored"
  type        = string
}

# ARN of the request S3 bucket
variable "request_bucket_arn" {
  description = "ARN of the S3 bucket for translation requests"
  type        = string
}

# ARN of the response S3 bucket
variable "response_bucket_arn" {
  description = "ARN of the S3 bucket for translation responses"
  type        = string
}

# Tags for resource organization
variable "tags" {
  description = "Additional tags for the resource"
  type        = map(string)
}

# Project name (e.g., "CloudTranslationService")
variable "project" {
  description = "Project name"
  type        = string
}

# Environment (e.g., dev, staging, production)
variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

# AWS region where resources are deployed
variable "region" {
  description = "AWS region to deploy the resources"
  type        = string
}

# KMS key ID for encrypting environment variables and logs
variable "kms_key_id" {
  description = "The KMS key ID to use for server-side encryption"
  type        = string
}
