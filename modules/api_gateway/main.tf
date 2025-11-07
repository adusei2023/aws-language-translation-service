# ---------------------------------------------------------------------------------------------------------------------
# API GATEWAY REST API
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_api_gateway_rest_api" "main" {
  name        = "${var.project}-api-${var.environment}"
  description = "API Gateway for Language Translation Service"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = var.tags
}

# ---------------------------------------------------------------------------------------------------------------------
# API GATEWAY RESOURCE
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_api_gateway_resource" "translate" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "translate"
}

# ---------------------------------------------------------------------------------------------------------------------
# API GATEWAY METHOD (POST)
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_api_gateway_method" "translate" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.translate.id
  http_method   = var.api_gateway_method
  authorization = "NONE"
}

# ---------------------------------------------------------------------------------------------------------------------
# API GATEWAY INTEGRATION
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_api_gateway_integration" "translate" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.translate.id
  http_method = aws_api_gateway_method.translate.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambdaFunctionInvokeArn
}

# ---------------------------------------------------------------------------------------------------------------------
# CORS METHOD (OPTIONS)
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_api_gateway_method" "cors_method" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.translate.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

# ---------------------------------------------------------------------------------------------------------------------
# CORS INTEGRATION
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_api_gateway_integration" "cors_integration" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.translate.id
  http_method = aws_api_gateway_method.cors_method.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# METHOD RESPONSE FOR POST
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_api_gateway_method_response" "translate_200" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.translate.id
  http_method = aws_api_gateway_method.translate.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# METHOD RESPONSE FOR OPTIONS (CORS)
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_api_gateway_method_response" "cors_200" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.translate.id
  http_method = aws_api_gateway_method.cors_method.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# INTEGRATION RESPONSE FOR OPTIONS (CORS)
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_api_gateway_integration_response" "cors_integration_response" {
  depends_on = [aws_api_gateway_method_response.cors_200]

  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.translate.id
  http_method = aws_api_gateway_method.cors_method.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# INTEGRATION RESPONSE FOR POST (with CORS)
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_api_gateway_integration_response" "translate_integration_response" {
  depends_on = [aws_api_gateway_method_response.translate_200]

  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.translate.id
  http_method = aws_api_gateway_method.translate.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# API GATEWAY DEPLOYMENT
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_api_gateway_deployment" "main" {
  depends_on = [
    aws_api_gateway_method.translate,
    aws_api_gateway_integration.translate,
    aws_api_gateway_method.cors_method,
    aws_api_gateway_integration.cors_integration,
    aws_api_gateway_method_response.translate_200,
    aws_api_gateway_method_response.cors_200,
    aws_api_gateway_integration_response.cors_integration_response,
    aws_api_gateway_integration_response.translate_integration_response,
    aws_api_gateway_method.translate_get,
    aws_api_gateway_integration.translate_get,
    aws_api_gateway_method_response.translate_get_200
  ]

  rest_api_id = aws_api_gateway_rest_api.main.id
}

# ---------------------------------------------------------------------------------------------------------------------
# API GATEWAY STAGE
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_api_gateway_stage" "main" {
  deployment_id = aws_api_gateway_deployment.main.id
  rest_api_id   = aws_api_gateway_rest_api.main.id
  stage_name    = var.environment
  
  # Performance and monitoring settings
  xray_tracing_enabled = true
  
  tags = var.tags
}

# ---------------------------------------------------------------------------------------------------------------------
# API GATEWAY METHOD SETTINGS - Configure performance settings
# Note: Caching is disabled for POST requests as they typically have unique request bodies.
# Caching is implemented at Lambda (in-memory) and frontend (browser) levels instead.
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_api_gateway_method_settings" "translate_settings" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  stage_name  = aws_api_gateway_stage.main.stage_name
  method_path = "translate/POST"

  settings {
    metrics_enabled        = true
    logging_level          = "INFO"
    data_trace_enabled     = false
    throttling_rate_limit  = 100
    throttling_burst_limit = 50
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# LAMBDA PERMISSION
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambdaFunctionName
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.main.execution_arn}/*/*"
}

# ---------------------------------------------------------------------------------------------------------------------
# API GATEWAY METHOD (GET) - for health check or testing
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_api_gateway_method" "translate_get" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.translate.id
  http_method   = "GET"
  authorization = "NONE"
}

# ---------------------------------------------------------------------------------------------------------------------
# API GATEWAY INTEGRATION (GET)
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_api_gateway_integration" "translate_get" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.translate.id
  http_method = aws_api_gateway_method.translate_get.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambdaFunctionInvokeArn
}

# ---------------------------------------------------------------------------------------------------------------------
# METHOD RESPONSE FOR GET
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_api_gateway_method_response" "translate_get_200" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.translate.id
  http_method = aws_api_gateway_method.translate_get.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CLOUDWATCH ALARMS FOR API GATEWAY PERFORMANCE MONITORING
# ---------------------------------------------------------------------------------------------------------------------

# Alarm for API Gateway 4XX errors
resource "aws_cloudwatch_metric_alarm" "api_4xx_errors" {
  alarm_name          = "${var.project}-${var.environment}-api-4xx-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "4XXError"
  namespace           = "AWS/ApiGateway"
  period              = 60
  statistic           = "Sum"
  threshold           = 10
  alarm_description   = "This metric monitors API Gateway 4XX errors"
  treat_missing_data  = "notBreaching"

  dimensions = {
    ApiName = aws_api_gateway_rest_api.main.name
    Stage   = aws_api_gateway_stage.main.stage_name
  }

  tags = var.tags
}

# Alarm for API Gateway 5XX errors
resource "aws_cloudwatch_metric_alarm" "api_5xx_errors" {
  alarm_name          = "${var.project}-${var.environment}-api-5xx-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "5XXError"
  namespace           = "AWS/ApiGateway"
  period              = 60
  statistic           = "Sum"
  threshold           = 5
  alarm_description   = "This metric monitors API Gateway 5XX errors"
  treat_missing_data  = "notBreaching"

  dimensions = {
    ApiName = aws_api_gateway_rest_api.main.name
    Stage   = aws_api_gateway_stage.main.stage_name
  }

  tags = var.tags
}

# Alarm for API Gateway latency
resource "aws_cloudwatch_metric_alarm" "api_latency" {
  alarm_name          = "${var.project}-${var.environment}-api-latency"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "Latency"
  namespace           = "AWS/ApiGateway"
  period              = 60
  statistic           = "Average"
  threshold           = 2000  # Alert if average latency exceeds 2 seconds
  alarm_description   = "This metric monitors API Gateway latency"
  treat_missing_data  = "notBreaching"

  dimensions = {
    ApiName = aws_api_gateway_rest_api.main.name
    Stage   = aws_api_gateway_stage.main.stage_name
  }

  tags = var.tags
}

# Alarm for API Gateway cache hit count (to monitor caching effectiveness)
resource "aws_cloudwatch_metric_alarm" "api_cache_hit_count" {
  alarm_name          = "${var.project}-${var.environment}-api-cache-hit-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CacheHitCount"
  namespace           = "AWS/ApiGateway"
  period              = 300
  statistic           = "Sum"
  threshold           = 5
  alarm_description   = "This metric monitors API Gateway cache effectiveness"
  treat_missing_data  = "notBreaching"

  dimensions = {
    ApiName = aws_api_gateway_rest_api.main.name
    Stage   = aws_api_gateway_stage.main.stage_name
  }

  tags = var.tags
}
