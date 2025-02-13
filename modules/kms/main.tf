# Creates a new AWS Key Management Service (KMS) key for encryption and security.
resource "aws_kms_key" "project_encryption_key" {
  description              = var.kms_config["description"]
  deletion_window_in_days  = var.kms_config["deletion_window_in_days"]
  enable_key_rotation      = var.kms_config["enable_key_rotation"]
  key_usage                = var.kms_config["key_usage"]
  customer_master_key_spec = var.kms_config["customer_master_key_spec"]

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "project-kms-policy"
    Statement = concat(
      [
        {
          # Grants full control to the AWS root account user.
          Sid    = "GrantRootFullAccess"
          Effect = "Allow"
          Principal = {
            AWS = "arn:aws:iam::${data.aws_caller_identity.current_account.account_id}:root"
          }
          Action   = "kms:*"
          Resource = "*"
        },
        {
          # Allows AWS S3 and CloudWatch Logs services to encrypt and decrypt data using this key.
          Sid    = "AllowS3AndLogsEncryption"
          Effect = "Allow"
          Principal = {
            Service = ["s3.amazonaws.com", "logs.amazonaws.com"]
          }
          Action = [
            "kms:Encrypt",
            "kms:Decrypt",
            "kms:GenerateDataKey*",
            "kms:DescribeKey"
          ]
          Resource = "*"
        },
        {
          # Grants access to IAM roles used within the project.
          Sid    = "AllowProjectRoles"
          Effect = "Allow"
          Principal = {
            AWS = "arn:aws:iam::${data.aws_caller_identity.current_account.account_id}:root"
          }
          Action = [
            "kms:Encrypt",
            "kms:Decrypt",
            "kms:GenerateDataKey*",
            "kms:DescribeKey"
          ]
          Resource = "*"
          Condition = {
            "StringLike" : {
              "aws:PrincipalArn": "arn:aws:iam::${data.aws_caller_identity.current_account.account_id}:role/${var.project_name}-*"
            }
          }
        }
      ],
      
      # Grants full administrative access to key owners.
      length(var.key_owners) > 0 ? [
        {
          Sid    = "GrantFullAccessToKeyOwners"
          Effect = "Allow"
          Principal = {
            AWS = var.key_owners
          }
          Action   = "kms:*"
          Resource = "*"
        }
      ] : [],

      # Grants administrative permissions to key admins (without encryption/decryption rights).
      length(var.key_admins) > 0 ? [
        {
          Sid    = "GrantAdminPermissionsToKeyAdmins"
          Effect = "Allow"
          Principal = {
            AWS = var.key_admins
          }
          Action = [
            "kms:Create*",
            "kms:Describe*",
            "kms:Enable*",
            "kms:List*",
            "kms:Put*",
            "kms:Update*",
            "kms:Revoke*",
            "kms:Disable*",
            "kms:Get*",
            "kms:Delete*",
            "kms:ScheduleKeyDeletion",
            "kms:CancelKeyDeletion"
          ]
          Resource = "*"
        }
      ] : [],

      # Grants encryption and decryption permissions to key users.
      length(var.key_users) > 0 ? [
        {
          Sid    = "GrantEncryptionAccessToKeyUsers"
          Effect = "Allow"
          Principal = {
            AWS = var.key_users
          }
          Action = [
            "kms:Encrypt",
            "kms:Decrypt",
            "kms:ReEncrypt*",
            "kms:GenerateDataKey*",
            "kms:DescribeKey"
          ]
          Resource = "*"
        }
      ] : []
    )
  })

  tags = merge(
    var.resource_tags,
    {
      Name = "${var.project_name}-${var.deployment_environment}-kms-key"
    }
  )
}

# Creates an alias for the KMS key to allow easier reference.
resource "aws_kms_alias" "project_kms_alias" {
  for_each      = { for alias in var.kms_aliases : alias => alias }
  name          = each.value
  target_key_id = aws_kms_key.project_encryption_key.id
}
