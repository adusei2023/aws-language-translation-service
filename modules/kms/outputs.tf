# Outputs the KMS Key ID, which can be referenced in other Terraform modules.
output "kms_key_id" {
  description = "The ID of the created KMS key"
  value       = aws_kms_key.project_encryption_key.id
}

# Outputs the KMS Key ARN (Amazon Resource Name) for reference.
output "kms_key_arn" {
  description = "The ARN of the created KMS key"
  value       = aws_kms_key.project_encryption_key.arn
}
