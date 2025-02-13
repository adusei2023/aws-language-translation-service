# IAM Policy Document for allowing Lambda access to the S3 bucket
data "aws_iam_policy_document" "s3_bucket_policy" {
  statement {
    # Allow the specified actions on objects in this bucket
    actions   = var.bucket_policy_actions
    resources = ["${aws_s3_bucket.translation_bucket.arn}/*"]

    # Restrict access to AWS Lambda service only
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}
