data "archive_file" "lambda_package" {
  type        = "zip"
  source_file = "${path.module}/lambda_translate.py"
  output_path = "${path.module}/lambda_translate.zip"
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}
