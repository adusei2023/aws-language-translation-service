# ---------------------------------------------------------------------------------------------------------------------
# IAM POLICY DOCUMENT - DEFINE ACCESS CONTROL FOR THE S3 BUCKET
# This policy allows AWS Lambda to perform the specified actions (e.g., s3:PutObject)
# on objects within the bucket. The policy ensures that only Lambda has write access.
# ---------------------------------------------------------------------------------------------------------------------

data "aws_iam_policy_document" "this" {
  # Statement for bucket-level actions (ListBucket)
  statement {
    sid    = "AllowListBucket"
    effect = "Allow"
    
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    
    actions = [
      "s3:ListBucket"
    ]
    
    resources = [
      "arn:aws:s3:::${var.bucket_name}"
    ]
  }
  
  # Statement for object-level actions (GetObject, PutObject)
  statement {
    sid    = "AllowObjectAccess"
    effect = "Allow"
    
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    
    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]
    
    resources = [
      "arn:aws:s3:::${var.bucket_name}/*"
    ]
  }
}

# Get current AWS account ID
data "aws_caller_identity" "current" {}
