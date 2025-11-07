# Creates the AWS Lambda function
resource "aws_lambda_function" "this" {
  function_name    = var.function_name
  handler          = "lambda_translate.lambda_handler"
  kms_key_arn      = var.kms_key_id                             # KMS encryption for environment variables
  memory_size      = 256                                        # Memory allocated to the function (increased for better performance)
  timeout          = 30                                         # Timeout in seconds (explicit timeout for translation operations)
  reserved_concurrent_executions = 10                           # Reserved concurrency to prevent throttling
  package_type     = "Zip"                                      # Function code is packaged as a ZIP file
  role             = aws_iam_role.this.arn                      # IAM role assigned to Lambda
  runtime          = "python3.12"                               # Lambda runtime environment
  filename         = "${path.module}/lambda_translate.zip"      # ZIP file containing Lambda code
  source_code_hash = data.archive_file.this.output_base64sha256 # Ensures updates are deployed

  # Enables AWS X-Ray tracing for debugging and monitoring
  tracing_config {
    mode = "Active"
  }

  # Environment variables passed to the Lambda function
  environment {
    variables = {
      REQUEST_BUCKET  = var.request_bucket  # Changed from request_bucket_name
      RESPONSE_BUCKET = var.response_bucket # Changed from response_bucket_name
      POWERTOOLS_SERVICE_NAME = "translation-service"
      LOG_LEVEL = "INFO"
    }
  }

  # Configures logging for Lambda
  logging_config {
    log_format = "Text"
    log_group  = aws_cloudwatch_log_group.this.name
  }

  # Tags to help with resource identification
  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.environment}-LambdaFunction"
    }
  )

  depends_on = [
    aws_cloudwatch_log_group.this,
  ]
}

# CloudWatch log group for Lambda function logs
resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = 7              # Log retention policy (7 days for better debugging)
  kms_key_id        = var.kms_key_id # Encrypts logs using KMS

  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.environment}-Lambda-LogGroup"
    }
  )
}
