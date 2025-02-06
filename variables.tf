variable "aws_region" {
  description = "AWS region to deploy the resources"
  type        = string
  default     = "us-east-1"
}

# S3 Buckets for Requests and Responses
variable "s3_requests_bucket" {
  description = "S3 bucket name for storing translation requests"
  default = "requests_bucket_007"
  type        = string
}

variable "s3_responses_bucket" {
  description = "S3 bucket name for storing translation responses"
  type        = string
  default     = "response_bucket_007"  
}

variable "lambda_name" {
  description = "Name of the Lambda function"
  type        = string
  default     = "lambda_translate"
}
