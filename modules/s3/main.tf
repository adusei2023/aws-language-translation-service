# Create the S3 bucket for translation requests or responses
resource "aws_s3_bucket" "translation_bucket" {
  bucket = var.bucket_name

  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.environment}-TranslationBucket"
    }
  )
}

# Apply server-side encryption using AWS KMS for data security
resource "aws_s3_bucket_server_side_encryption_configuration" "s3_encryption" {
  bucket = aws_s3_bucket.translation_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_id
      sse_algorithm     = "aws:kms"
    }
  }
}

# Enforce strict public access restrictions for security
resource "aws_s3_bucket_public_access_block" "s3_public_access" {
  bucket                  = aws_s3_bucket.translation_bucket.id
  block_public_acls       = true   # Block public ACLs
  block_public_policy     = true   # Block public bucket policies
  ignore_public_acls      = true   # Ignore any public ACLs
  restrict_public_buckets = true   # Fully restrict public access
}

# Attach the IAM policy to the S3 bucket
resource "aws_s3_bucket_policy" "s3_bucket_policy_attachment" {
  bucket = aws_s3_bucket.translation_bucket.id
  policy = data.aws_iam_policy_document.s3_bucket_policy.json
}
