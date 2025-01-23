variable "aws_region" {
  description = "AWS region where resources will be deployed"
  default     = "us-east-1"
}

variable "translation_requests_bucket" {
  description = "Name of the S3 bucket for storing translation requests"
  default     = "translation-requests-bucket"
}

variable "translation_responses_bucket" {
  description = "Name of the S3 bucket for storing translation responses"
  default     = "translation-responses-bucket"
}

variable "lambda_execution_role_name" {
  description = "Name of the IAM role for Lambda execution"
  default     = "translation-lambda-role"
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  default     = "TranslationLambda"
}

variable "lambda_zip_file" {
  description = "Path to the zipped Lambda deployment package"
  default     = "path/to/lambda_translate.zip"
}
