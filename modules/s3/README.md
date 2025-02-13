# S3 Module for Translation Requests and Responses

## Overview
This module creates an **Amazon S3 bucket** for storing translation requests and responses. It ensures **secure storage** with **KMS encryption**, **IAM-based access control**, and **public access restrictions**.

## Features
- **Creates a secure S3 bucket** for storing text to be translated.
- **Applies AWS KMS encryption** for data security.
- **Restricts public access** to prevent unauthorized access.
- **Attaches an IAM policy** to allow only AWS Lambda access.

## Resources Created
- `aws_s3_bucket.translation_bucket` - The S3 bucket.
- `aws_s3_bucket_server_side_encryption_configuration.s3_encryption` - Encryption settings.
- `aws_s3_bucket_public_access_block.s3_public_access` - Public access restrictions.
- `aws_s3_bucket_policy.s3_bucket_policy_attachment` - IAM policy for access control.

## Variables
| Name                  | Type          | Description |
|-----------------------|--------------|-------------|
| `bucket_name`        | `string`      | The name of the S3 bucket |
| `kms_key_id`        | `string`      | AWS KMS key for encryption |
| `bucket_policy_actions` | `list(string)` | Allowed actions in the IAM bucket policy |
| `region`             | `string`      | AWS Region for deployment |
| `project`            | `string`      | Name of the project |
| `environment`        | `string`      | Deployment environment (e.g., dev, prod) |

## Outputs
| Name                          | Description |
|--------------------------------|-------------|
| `s3_translation_bucket_name`   | The name of the created S3 bucket |
| `s3_translation_bucket_arn`    | The ARN of the created S3 bucket |

## Usage
```hcl
module "translation_s3_bucket" {
  source                = "./modules/s3"
  bucket_name           = "translation-storage-bucket"
  kms_key_id            = aws_kms_key.this.arn
  project               = "TranslationService"
  environment           = "production"
  region                = "us-east-1"
  bucket_policy_actions = ["s3:GetObject", "s3:PutObject"]
  tags = {
    Owner = "George"
  }
}
