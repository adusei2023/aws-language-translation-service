# Create IAM Role for the Lambda function
resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"

  # Trust relationship: Allows Lambda to assume this role
  assume_role_policy = data.aws_iam_policy_document.lambda_trust.json
}

# Trust policy: Only AWS Lambda can assume this role
data "aws_iam_policy_document" "lambda_trust" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

# IAM Policy to allow Lambda to write to S3
resource "aws_iam_policy" "s3_policy" {
  name        = "lambda_s3_policy"
  description = "Allows Lambda to write and read from S3"

  policy = data.aws_iam_policy_document.s3_policy.json
}

# Policy Document for S3 Access
data "aws_iam_policy_document" "s3_policy" {
  statement {
    effect = "Allow"
    actions = ["s3:PutObject", "s3:GetObject"]
    resources = [
      "${var.requests_bucket_arn}/*",
      "${var.responses_bucket_arn}/*"
    ]
  }
}

# IAM Policy to allow Lambda to use AWS Translate
resource "aws_iam_policy" "translate_policy" {
  name        = "lambda_translate_policy"
  description = "Allows Lambda to use AWS Translate"

  policy = data.aws_iam_policy_document.translate_policy.json
}

# Policy Document for AWS Translate Access
data "aws_iam_policy_document" "translate_policy" {
  statement {
    effect = "Allow"
    actions = ["translate:TranslateText"]
    resources = ["*"]  # Lambda can translate any text
  }
}

# Attach the S3 policy to the Lambda role
resource "aws_iam_role_policy_attachment" "s3_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.s3_policy.arn
}

# Attach the Translate policy to the Lambda role
resource "aws_iam_role_policy_attachment" "translate_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.translate_policy.arn
}
