# Create the S3 bucket for storing translation requests
resource "aws_s3_bucket" "requests_bucket" {
  bucket = var.requests_bucket_name
}

# Create the S3 bucket for storing translation responses
resource "aws_s3_bucket" "responses_bucket" {
  bucket = var.responses_bucket_name
}

# Restrict public access to the requests bucket
resource "aws_s3_bucket_public_access_block" "requests_bucket_access" {
  bucket                  = aws_s3_bucket.requests_bucket.id
  block_public_acls       = true  # Prevents public ACL settings
  block_public_policy     = true  # Blocks public bucket policies
  ignore_public_acls      = true  # Ignores existing public ACLs
  restrict_public_buckets = true  # Ensures no public access
}

# Restrict public access to the responses bucket
resource "aws_s3_bucket_public_access_block" "responses_bucket_access" {
  bucket                  = aws_s3_bucket.responses_bucket.id
  block_public_acls       = true  
  block_public_policy     = true  
  ignore_public_acls      = true  
  restrict_public_buckets = true  
}

# Define an S3 bucket policy for the requests bucket
resource "aws_s3_bucket_policy" "requests_bucket_policy" {
  bucket = aws_s3_bucket.requests_bucket.id
  policy = data.aws_iam_policy_document.requests_bucket_policy.json
}

# Define an S3 bucket policy for the responses bucket
resource "aws_s3_bucket_policy" "responses_bucket_policy" {
  bucket = aws_s3_bucket.responses_bucket.id
  policy = data.aws_iam_policy_document.responses_bucket_policy.json
}

# IAM Policy Document for the requests bucket
data "aws_iam_policy_document" "requests_bucket_policy" {
  statement {
    actions   = ["s3:PutObject"]  # Allow writing files
    resources = ["${aws_s3_bucket.requests_bucket.arn}/*"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]  # Only AWS Lambda can write
    }
  }
}

# IAM Policy Document for the responses bucket
data "aws_iam_policy_document" "responses_bucket_policy" {
  statement {
    actions   = ["s3:PutObject", "s3:GetObject"]  # Allow writing and reading
    resources = ["${aws_s3_bucket.responses_bucket.arn}/*"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]  # Only AWS Lambda can read and write
    }
  }
}
