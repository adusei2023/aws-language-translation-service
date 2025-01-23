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
  #specifics to be added later
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
  #to be added 
}


