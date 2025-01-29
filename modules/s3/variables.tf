# Variable for the translation requests bucket name
variable "requests_bucket_name" {
  description = "S3 bucket name for storing translation requests"
  type        = string
}

# Variable for the translation responses bucket name
variable "responses_bucket_name" {
  description = "S3 bucket name for storing translation responses"
  type        = string
}
