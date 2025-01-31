variable "aws_region" {
  description = "AWS region to deploy the resources"
  type        = string
  default     = "us-east-1"
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "lambda_name" {
  description = "Name of the Lambda function"
  type        = string
  default     = "lambda_translate"
}
