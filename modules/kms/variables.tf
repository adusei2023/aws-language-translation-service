# Defines resource tags for proper organization.
variable "resource_tags" {
  description = "Additional tags for AWS resources"
  type        = map(string)
}

# Defines the project name.
variable "project_name" {
  description = "The name of the project using this KMS key"
  type        = string
}

# Defines the environment (e.g., dev, prod).
variable "deployment_environment" {
  description = "The environment where this KMS key is deployed"
  type        = string
}

# Defines the AWS region for deployment.
variable "aws_region" {
  description = "The AWS region for deployment"
  type        = string
}

# Defines the KMS key configuration as a map.
variable "kms_config" {
  description = "Configuration for the KMS key, including description, key usage, and rotation settings"
  type        = map(any)
}

# Defines a list of aliases for the KMS key.
variable "kms_aliases" {
  description = "List of aliases for the KMS key (e.g., ['alias/project-key'])"
  type        = list(string)
}

# Defines IAM principal ARNs with full control over the key.
variable "key_owners" {
  description = "List of IAM ARNs that have full administrative control over the key"
  type        = list(string)
}

# Defines IAM principal ARNs that can administer but not use the key.
variable "key_admins" {
  description = "List of IAM ARNs with administrative permissions for the key"
  type        = list(string)
}

# Defines IAM principal ARNs that can use the key for encryption/decryption.
variable "key_users" {
  description = "List of IAM ARNs that are allowed to encrypt/decrypt using this key"
  type        = list(string)
}
