# 🔐 KMS Encryption Module

## Overview
This module creates and configures AWS Key Management Service (KMS) customer-managed keys for encrypting data at rest throughout the translation service infrastructure. It provides centralized encryption key management with proper IAM controls.

## 🏗️ Architecture
- **Customer-Managed Key**: Full control over key lifecycle and permissions
- **Key Rotation**: Automatic annual key rotation for enhanced security
- **Multi-Service Usage**: Encrypts S3 objects, Lambda environment variables, and CloudWatch logs
- **IAM Integration**: Granular permissions for key owners, admins, and users
- **Audit Trail**: CloudTrail logging for all key usage

## 📦 Resources Created
- `aws_kms_key` - Customer-managed encryption key
- `aws_kms_alias` - Human-readable alias for the key
- Key policy with IAM principal permissions

## 📋 Variables

| Variable | Type | Description |
|----------|------|-------------|
| `project` | `string` | Project name for tagging and naming |
| `environment` | `string` | Environment name (dev, staging, production) |
| `region` | `string` | AWS region for deployment |
| `tags` | `map(string)` | Additional resource tags |
| `kms_vars` | `map(any)` | KMS key configuration parameters |
| `aliases` | `list(string)` | List of aliases for the KMS key |
| `key_owners` | `list(string)` | IAM ARNs with full key control |
| `key_admins` | `list(string)` | IAM ARNs for key administration |
| `key_users` | `list(string)` | IAM ARNs allowed to use the key |

## 📤 Outputs

| Output | Description |
|--------|-------------|
| `key_id` | The ID of the created KMS key |
| `key_arn` | The ARN of the created KMS key |

## 🚀 Usage

```hcl
module "kms_key" {
  source      = "./modules/kms"
  project     = "aws-translate"
  environment = "production"
  region      = "us-east-1"
  tags = {
    CreatedBy = "Samuel Adusei Boateng"
  }
  
  # Key configuration
  kms_vars = {
    description              = "KMS key for language translation service"
    deletion_window_in_days  = 7
    enable_key_rotation      = true
    key_usage                = "ENCRYPT_DECRYPT"
    customer_master_key_spec = "SYMMETRIC_DEFAULT"
  }
  
  # Key aliases
  aliases = ["alias/aws-translate-key"]
  
  # IAM permissions
  key_owners = ["arn:aws:iam::ACCOUNT-ID:root"]
  key_admins = ["arn:aws:iam::ACCOUNT-ID:root"]
  key_users  = [
    "arn:aws:iam::ACCOUNT-ID:role/aws-translate-production-LambdaRole"
  ]
}
```

## 🔒 Security Features

### Key Configuration
- **Symmetric Encryption**: AES-256 encryption standard
- **Key Rotation**: Automatic annual rotation
- **Deletion Protection**: 7-day minimum deletion window
- **Regional Scope**: Key bound to specific AWS region

### Access Control
- **Key Owners**: Full administrative control over the key
- **Key Admins**: Can modify key settings and policies
- **Key Users**: Can encrypt/decrypt data using the key
- **Least Privilege**: Minimal permissions for each role

## 🛡️ KMS Variables Configuration

| Parameter | Default | Description |
|-----------|---------|-------------|
| `description` | "Project KMS key" | Human-readable key description |
| `deletion_window_in_days` | 30 | Days before permanent deletion (7-30) |
| `enable_key_rotation` | true | Enable automatic key rotation |
| `key_usage` | "ENCRYPT_DECRYPT" | Intended key usage |
| `customer_master_key_spec` | "SYMMETRIC_DEFAULT" | Key specification type |

## 🎯 Use Cases in Translation Service

### S3 Encryption
- Request bucket objects
- Response bucket objects
- Frontend static files (optional)

### Lambda Environment Variables
- S3 bucket names
- API configuration
- Service settings

### CloudWatch Logs
- Lambda function logs
- API Gateway access logs
- System operation logs

## 💰 Cost Considerations
- **Key Storage**: $1/month per key
- **API Requests**: $0.03 per 10,000 requests
- **Key Rotation**: Automatic, no additional cost
- **Cross-Region**: Additional charges for cross-region usage

## 🔍 Monitoring
- **CloudTrail**: All key usage logged
- **CloudWatch Metrics**: Key usage statistics
- **Key Policies**: Regular policy reviews recommended
- **Access Patterns**: Monitor for unusual activity

## 📋 Best Practices
- ✅ Enable key rotation for long-term keys
- ✅ Use least-privilege IAM policies
- ✅ Regular review of key permissions
- ✅ Monitor key usage with CloudTrail
- ✅ Use aliases instead of key IDs in applications
- ✅ Implement proper key deletion procedures

## 📝 Notes
- Key aliases must be unique within the AWS account and region
- Key policies are automatically generated based on provided IAM ARNs
- Keys cannot be used across AWS regions
- Deletion window prevents accidental key loss
- Key material is never accessible outside AWS KMS
