# ARN of the translation requests S3 bucket
variable "requests_bucket_arn" {
  description = "ARN of the S3 bucket for storing translation requests"
  type        = string
}

# ARN of the translation responses S3 bucket
variable "responses_bucket_arn" {
  description = "ARN of the S3 bucket for storing translation responses"
  type        = string
}
