# ===========================
#   Global Variables
# ===========================

# Project name
variable "project" {
  description = "Project name for tagging and organization"
  type        = string
  default     = "aws-translate"
}

# Deployment environment (e.g., dev, staging, prod)
variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

# AWS region for deploying resources
variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

# Common tags for resource tracking
variable "tags" {
  description = "Tags for AWS resources"
  type        = map(string)
  default = {
    CreatedBy = "George"
  }
}

# ===========================
#   KMS Configuration
# ===========================

variable "kms_settings" {
  type = map(any)
  default = {
    description              = "Project KMS key"
    deletion_window_in_days  = 30
    enable_key_rotation      = true
    key_usage                = "ENCRYPT_DECRYPT"
    customer_master_key_spec = "SYMMETRIC_DEFAULT"
  }
}

variable "kms_aliases" {
  description = "List of KMS key aliases"
  type        = list(string)
  default = [
    "alias/translate-key"
  ]
}

variable "kms_key_owners" {
  description = "IAM ARNs with full control over the KMS key"
  type        = list(string)
  default = [
    "arn:aws:iam::522986700920:user/crommie"
  ]
}

variable "kms_key_admins" {
  description = "IAM ARNs allowed to administer the KMS key"
  type        = list(string)
  default     = []
}

variable "kms_key_users" {
  description = "IAM ARNs allowed to use the KMS key for encryption/decryption"
  type        = list(string)
  default     = []
}

# ===========================
#   Lambda Configuration
# ===========================

variable "lambda_function_name" {
  description = "Name of the AWS Lambda function"
  type        = string
  default     = "translate-function"
}

variable "lambda_function_handler" {
  description = "Handler function inside the Lambda script"
  type        = string
  default     = "lambda_translate.lambda_handler"
}

# ===========================
#   S3 Buckets Configuration
# ===========================

variable "translation_request_bucket" {
  description = "S3 bucket for storing translation request files"
  type        = string
  default     = "translation-requests-storage"
}

variable "translation_response_bucket" {
  description = "S3 bucket for storing translated response files"
  type        = string
  default     = "translation-responses-storage"
}

# ===========================
#   S3 Bucket Policies
# ===========================

variable "request_bucket_policy_actions" {
  description = "Allowed actions in the request bucket policy"
  type        = list(string)
  default     = ["s3:PutObject"]
}

variable "response_bucket_policy_actions" {
  description = "Allowed actions in the response bucket policy"
  type        = list(string)
  default     = ["s3:PutObject", "s3:GetObject"]
}
