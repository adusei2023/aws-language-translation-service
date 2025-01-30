variable "lambda_function_name" {
  description = "The name of the Lambda function"
  type        = string
}

variable "lambda_role_arn" {
  description = "IAM Role ARN that the Lambda function will assume"
  type        = string
}

variable "s3_requests_bucket" {
  description = "The name of the S3 bucket where translation requests are stored"
  type        = string
}

variable "s3_responses_bucket" {
  description = "The name of the S3 bucket where translation responses are stored"
  type        = string
}
