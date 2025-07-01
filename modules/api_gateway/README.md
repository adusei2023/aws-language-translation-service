# 🌐 API Gateway Module

## Overview
This module creates an AWS API Gateway REST API that serves as the HTTP interface for the language translation service. It provides a secure, scalable endpoint for clients to submit translation requests and includes full CORS support for web applications.

## 🏗️ Architecture
- **REST API**: Regional endpoint for optimal performance
- **CORS Support**: Enables web browser access with proper preflight handling
- **Lambda Integration**: AWS Proxy integration with the translation Lambda function
- **Multiple Methods**: Support for POST (translation), GET (health check), and OPTIONS (CORS)

## 📦 Resources Created
- `aws_api_gateway_rest_api` - Main REST API
- `aws_api_gateway_resource` - `/translate` resource path
- `aws_api_gateway_method` - POST, GET, and OPTIONS methods
- `aws_api_gateway_integration` - Lambda proxy integrations
- `aws_api_gateway_method_response` - Response configurations with CORS headers
- `aws_api_gateway_integration_response` - Integration response mappings
- `aws_api_gateway_deployment` - API deployment
- `aws_api_gateway_stage` - Deployment stage (typically "production" or "dev")
- `aws_lambda_permission` - Allows API Gateway to invoke Lambda function

## 📋 Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `project` | `string` | - | Project name for resource tagging |
| `environment` | `string` | - | Environment name (dev, staging, production) |
| `region` | `string` | - | AWS region for deployment |
| `tags` | `map(string)` | - | Additional tags for resources |
| `kms_key_id` | `string` | - | KMS key ID for encryption |
| `lambdaFunctionName` | `string` | - | Name of the Lambda function to integrate |
| `lambdaFunctionInvokeArn` | `string` | - | Lambda function invoke ARN |
| `api_gateway_method` | `string` | - | HTTP method for the main endpoint (POST) |
| `api_gateway_route` | `string` | - | Route path for the API endpoint (/translate) |

## 📤 Outputs

| Output | Description |
|--------|-------------|
| `api_gateway_id` | The ID of the created API Gateway |
| `api_gateway_endpoint` | The full invoke URL of the API Gateway |
| `api_gateway_execution_arn` | The execution ARN of the API Gateway |
| `stage_name` | The name of the deployment stage |

## 🚀 Usage

```hcl
module "api_gateway" {
  source                  = "./modules/api_gateway"
  project                 = "aws-translate"
  environment             = "production"
  region                  = "us-east-1"
  tags                    = {
    CreatedBy = "Samuel Adusei Boateng"
  }
  kms_key_id              = module.kms_key.key_arn
  api_gateway_route       = "/translate"
  api_gateway_method      = "POST"
  lambdaFunctionName      = module.lambda.function_name
  lambdaFunctionInvokeArn = module.lambda.lambda_invoke_arn
}
```

## 🔧 API Endpoints

### POST /translate
- **Purpose**: Submit text for translation
- **Content-Type**: application/json
- **Request Body**:
```json
{
  "source_language": "en",
  "target_language": "es",
  "text": "Hello world"
}
```

### GET /translate
- **Purpose**: Health check endpoint
- **Response**: Returns service status

### OPTIONS /translate
- **Purpose**: CORS preflight requests
- **Response**: Returns CORS headers for browser compatibility

## 🔒 Security Features
- **CORS Configuration**: Proper headers for web application access
- **Lambda Integration**: Secure proxy integration with AWS Lambda
- **Regional Endpoint**: Enhanced security and performance
- **IAM Permissions**: Least-privilege access controls

## 📝 Notes
- The API Gateway automatically handles request/response transformation
- CORS is configured to allow all origins (`*`) for development convenience
- The stage name matches the environment variable
- All responses include appropriate CORS headers