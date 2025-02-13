# Define the AWS Lambda function
resource "aws_lambda_function" "translate_function" {
  function_name    = var.function_name
  handler          = var.function_handler
  kms_key_arn      = var.kms_key_id   # Use KMS for encrypting environment variables and logs
  memory_size      = 128              # Set Lambda memory size
  package_type     = "Zip"
  role             = aws_iam_role.lambda_execution_role.arn  # Attach IAM execution role
  runtime          = "python3.12"
  filename         = "${path.module}/lambda_translate.zip"  # Path to the Lambda deployment package
  source_code_hash = data.archive_file.lambda_package.output_base64sha256  # Ensure Lambda updates only on code changes

  # Enable AWS X-Ray tracing for monitoring and debugging
  tracing_config {
    mode = "Active"
  }

  # Define environment variables for S3 buckets
  environment {
    variables = {
      REQUEST_BUCKET  = var.request_bucket
      RESPONSE_BUCKET = var.response_bucket
    }
  }

  # Set up logging configuration for CloudWatch
  logging_config {
    log_format = "Text"
    log_group  = aws_cloudwatch_log_group.lambda_log_group.name
  }

  # Assign tags for better resource tracking
  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.environment}-TranslateLambda"
    }
  )

  # Ensure the log group exists before creating Lambda
  depends_on = [
    aws_cloudwatch_log_group.lambda_log_group,
  ]
}

# Create a CloudWatch Log Group for Lambda logs
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = 1         # Keep logs for 1 day to minimize costs
  kms_key_id        = var.kms_key_id  # Encrypt logs using KMS

  # Assign tags for easy resource tracking
  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.environment}-LambdaLogGroup"
    }
  )
}
