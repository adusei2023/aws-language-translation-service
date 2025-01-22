# Specify the AWS provider
provider "aws" {
  region = var.aws_region
}

# Define placeholders for S3 buckets
resource "aws_s3_bucket" "translation_requests" {
  bucket = var.translation_requests_bucket
  # Additional configuration (e.g., versioning, tags) can be added later
}

resource "aws_s3_bucket" "translation_responses" {
  bucket = var.translation_responses_bucket
  # Additional configuration (e.g., versioning, tags) can be added later
}

# Placeholder for IAM Role
resource "aws_iam_role" "lambda_execution_role" {
  name               = var.lambda_execution_role_name
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

# Placeholder for IAM Policy Attachment
resource "aws_iam_policy_attachment" "lambda_s3_translate_policy" {
  name       = "lambda_s3_translate_attachment"
  roles      = [aws_iam_role.lambda_execution_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonTranslateFullAccess"
}

# Placeholder for Lambda Function
resource "aws_lambda_function" "translate_lambda" {
  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "lambda_translate.lambda_handler"
  runtime       = "python3.8"
  
  # Code source will be added later
  filename         = var.lambda_zip_file
  source_code_hash = filebase64sha256(var.lambda_zip_file)
}

# Outputs
output "s3_translation_requests_bucket" {
  description = "Name of the S3 bucket for translation requests"
  value       = aws_s3_bucket.translation_requests.id
}

output "s3_translation_responses_bucket" {
  description = "Name of the S3 bucket for translation responses"
  value       = aws_s3_bucket.translation_responses.id
}

output "lambda_function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.translate_lambda.arn
}
