variable "bucket_name" {
  description = "The name of the S3 bucket to create for translation data"
  type        = string
}

variable "kms_key_id" {
  description = "The KMS key ID used for encrypting objects in the S3 bucket"
  type        = string
}

variable "tags" {
  description = "Additional metadata tags for the S3 bucket"
  type        = map(string)
}

variable "project" {
  description = "The project name associated with this S3 bucket"
  type        = string
}

variable "environment" {
  description = "The deployment environment (e.g., dev, prod, staging)"
  type        = string
}

variable "region" {
  description = "AWS region where the S3 bucket will be deployed"
  type        = string
}

variable "bucket_policy_actions" {
  description = "List of S3 actions allowed in the bucket policy"
  type        = list(string)
}
