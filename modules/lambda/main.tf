resource "aws_lambda_function" "translate_lambda" {
  function_name = var.lambda_function_name
  role          = var.lambda_role_arn
  handler       = "lambda_translate.lambda_handler"
  runtime       = "python3.9"
  filename      = "${path.module}/lambda.zip"
  timeout       = 10

  environment {
    variables = {
      REQUESTS_BUCKET = var.s3_requests_bucket
      RESPONSES_BUCKET = var.s3_responses_bucket
    }
  }
}

resource "null_resource" "package_lambda" {
  provisioner "local-exec" {
    command = "zip -j ${path.module}/lambda.zip ${path.module}/lambda_translate.py"
  }

  triggers = {
    script_hash = filemd5("${path.module}/lambda_translate.py")
  }
}
