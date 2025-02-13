# AWS KMS Key Module

## Overview
This module provisions an **AWS Key Management Service (KMS) key** to securely encrypt data for your AWS project. 
It includes **customizable IAM policies** to define who can manage and use the key.

## Features
- **Custom KMS key with configurable options**
- **Key policies granting access to different IAM roles/services**
- **Automatic key rotation for better security**
- **Custom aliases for easy reference**
- **Granular IAM permission control**

## Resources Created
- `aws_kms_key`: Creates the KMS encryption key.
- `aws_kms_alias`: Assigns aliases for the KMS key.

## Inputs
| Variable          | Description                                           | Type         | Required |
|------------------|---------------------------------------------------|-------------|----------|
| `project_name`   | Name of the project.                               | `string`    | Yes      |
| `deployment_environment` | Deployment environment (e.g., dev, prod).         | `string`    | Yes      |
| `aws_region`     | AWS region to deploy the resources.                 | `string`    | Yes      |
| `kms_config`     | Map containing KMS key configuration settings.      | `map(any)`  | Yes      |
| `kms_aliases`    | List of aliases for the KMS key.                   | `list(string)` | No  |
| `key_owners`     | IAM ARNs with full control over the key.           | `list(string)` | No |
| `key_admins`     | IAM ARNs with administrative access.               | `list(string)` | No |
| `key_users`      | IAM ARNs that can use the key for encryption.      | `list(string)` | No |

## Outputs
- `kms_key_id`: The ID of the created KMS key.
- `kms_key_arn`: The ARN of the created KMS key.
