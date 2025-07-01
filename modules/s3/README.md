# Ì∑ÑÔ∏è S3 Storage Module

## Overview
This module creates secure S3 buckets for storing translation requests and responses. Each bucket is configured with KMS encryption, public access blocking, and IAM policies for controlled access.

## ÌøóÔ∏è Architecture
- **Server-Side Encryption**: KMS encryption for all objects
- **Public Access Blocked**: Complete protection against public exposure
- **IAM Bucket Policies**: Controlled access for Lambda functions
- **Versioning**: Optional versioning support
- **Lifecycle Management**: Configurable lifecycle policies

## ÔøΩÔøΩ Resources Created
- `aws_s3_bucket` - Main storage bucket
- `aws_s3_bucket_server_side_encryption_configuration` - KMS encryption
- `aws_s3_bucket_public_access_block` - Public access protection
- `aws_s3_bucket_policy` - IAM access policy
- `aws_s3_bucket_versioning` - Version control (optional)

## Ì≥ã Variables

| Variable | Type | Description |
|----------|------|-------------|
| `bucket_name` | `string` | Unique name for the S3 bucket |
| `kms_key_id` | `string` | KMS key ARN for encryption |
| `tags` | `map(string)` | Resource tags for organization |
| `project` | `string` | Project name for tagging |
| `environment` | `string` | Environment name (dev, staging, production) |
| `region` | `string` | AWS region for deployment |
| `bucket_policy_actions` | `list(string)` | Allowed S3 actions for IAM policy |

## Ì≥§ Outputs

| Output | Description |
|--------|-------------|
| `bucket_name` | Name of the created S3 bucket |
| `bucket_arn` | ARN of the S3 bucket |
| `bucket_id` | ID of the S3 bucket |

## Ì∫Ä Usage

### Request Bucket (Write-Only)
```hcl
module "request_bucket" {
  source                = "./modules/s3"
  bucket_name           = "translation-requests-unique-suffix"
  kms_key_id            = module.kms_key.key_arn
  project               = "aws-translate"
  environment           = "production"
  region                = "us-east-1"
  bucket_policy_actions = ["s3:PutObject"]
  tags = {
    CreatedBy = "Samuel Adusei Boateng"
    Purpose   = "Translation Requests"
  }
}
```

### Response Bucket (Read-Write)
```hcl
module "response_bucket" {
  source                = "./modules/s3"
  bucket_name           = "translation-responses-unique-suffix"
  kms_key_id            = module.kms_key.key_arn
  project               = "aws-translate"
  environment           = "production"
  region                = "us-east-1"
  bucket_policy_actions = ["s3:PutObject", "s3:GetObject"]
  tags = {
    CreatedBy = "Samuel Adusei Boateng"
    Purpose   = "Translation Responses"
  }
}
```

## Ì¥í Security Features
- **KMS Encryption**: All objects encrypted at rest
- **Public Access Blocked**: No public read/write access
- **IAM Policies**: Principle of least privilege
- **Bucket Policies**: Resource-level access control

## Ì≥ä Common Policy Actions

| Action | Purpose |
|--------|---------|
| `s3:PutObject` | Upload objects to bucket |
| `s3:GetObject` | Download objects from bucket |
| `s3:ListBucket` | List bucket contents |
| `s3:DeleteObject` | Delete objects from bucket |

## Ì≤∞ Cost Optimization
- **Storage Class**: Standard (can be modified for lifecycle policies)
- **Encryption**: KMS encryption (minimal cost impact)
- **Lifecycle Policies**: Can be added for automatic archival

## Ì≥ù Notes
- Bucket names must be globally unique
- KMS encryption applies to all objects
- Public access is completely blocked by default
- IAM policies are scoped to specific actions only
