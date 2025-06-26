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
  type                   = "AWS_PROXY"
  uri                    = var.lambaFunctionInvokeArn
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
  type                   = "AWS_PROXY"
  uri                    = var.lambaFunctionInvokeArn
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
