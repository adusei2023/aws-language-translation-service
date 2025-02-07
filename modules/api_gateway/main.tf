# Create API Gateway REST API
resource "aws_api_gateway_rest_api" "translate_api" {
  name        = "TranslateAPI"
  description = "API Gateway for the translation service"
}

# Create API Resource (endpoint path)
resource "aws_api_gateway_resource" "translate_resource" {
  rest_api_id = aws_api_gateway_rest_api.translate_api.id
  parent_id   = aws_api_gateway_rest_api.translate_api.root_resource_id
  path_part   = "translate"  # URL will be /translate
}

# Define the POST method for the API
resource "aws_api_gateway_method" "post_method" {
  rest_api_id   = aws_api_gateway_rest_api.translate_api.id
  resource_id   = aws_api_gateway_resource.translate_resource.id
  http_method   = "POST"
  authorization = "NONE"  # Change if you want authentication
}

# Integrate API Gateway with Lambda
resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.translate_api.id
  resource_id             = aws_api_gateway_resource.translate_resource.id
  http_method             = aws_api_gateway_method.post_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn
}

# Create Deployment Stage
resource "aws_api_gateway_deployment" "translate_deployment" {
  rest_api_id = aws_api_gateway_rest_api.translate_api.id
  stage_name  = "dev"

  depends_on = [
    aws_api_gateway_integration.lambda_integration
  ]
}
