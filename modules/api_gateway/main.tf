# --------------------------------------------
# API Gateway: Creates an HTTP API Gateway 
# to expose the Lambda function as an endpoint.
# --------------------------------------------

# Define API Gateway
resource "aws_apigatewayv2_api" "api_gateway" {
  name          = "${var.project}-${var.environment}-APIGateway"
  protocol_type = "HTTP"

  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.environment}-APIGateway"
    }
  )
}

# Define API Gateway Stage (Deployment Stage)
resource "aws_apigatewayv2_stage" "api_stage" {
  api_id      = aws_apigatewayv2_api.api_gateway.id
  name        = "dev" # Default stage name
  auto_deploy = true  # Enables automatic deployment of changes

  # Configure Access Logging to CloudWatch
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_logs.arn

    # Log Format - Stores request metadata in JSON format
    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
    })
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.environment}-APIGatewayStage"
    }
  )
}

# Define Integration Between API Gateway & Lambda
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id             = aws_apigatewayv2_api.api_gateway.id
  integration_type   = "AWS_PROXY" # AWS_PROXY allows direct Lambda integration
  integration_method = "POST"

  # Lambda Invoke ARN
  integration_uri = var.lambda_function_invoke_arn
}

# Define API Gateway Route (HTTP Endpoint)
resource "aws_apigatewayv2_route" "translate_route" {
  api_id    = aws_apigatewayv2_api.api_gateway.id
  route_key = "GET /translate" # Defines the endpoint (GET request to /translate)
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

# Grant API Gateway Permission to Invoke Lambda
resource "aws_lambda_permission" "lambda_api_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"

  # Allow invocation from any method (GET, POST, etc.)
  source_arn = "${aws_apigatewayv2_api.api_gateway.execution_arn}/*/*"
}

# Create CloudWatch Log Group for API Gateway Logging
resource "aws_cloudwatch_log_group" "api_logs" {
  name              = "/aws/api-gw/${aws_apigatewayv2_api.api_gateway.name}"
  retention_in_days = 7 # Logs will be retained for 7 days
  kms_key_id        = var.kms_key_id # Uses KMS for encryption

  tags = merge(
    var.tags,
    {
      Name = "${var.project}-${var.environment}-APIGateway-LogGroup"
    }
  )
}
