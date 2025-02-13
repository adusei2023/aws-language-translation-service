# API Gateway Module

## Overview
This Terraform module provisions an **Amazon API Gateway (HTTP API)** that connects to an AWS Lambda function. The API allows users to send requests to the Lambda function, which processes translations using AWS Translate.

## Features
- Creates an **API Gateway** with an HTTP endpoint (`/translate`).
- **Integrates with Lambda** using an AWS_PROXY connection.
- Configures **CloudWatch logging** for API request tracking.
- Deploys an **API Stage** (`dev` environment).
- Grants API Gateway **permission to invoke Lambda**.

## Resources Created
- `aws_apigatewayv2_api` (API Gateway)
- `aws_apigatewayv2_stage` (Deployment Stage)
- `aws_apigatewayv2_integration` (Lambda Integration)
- `aws_apigatewayv2_route` (Defines `/translate` endpoint)
- `aws_lambda_permission` (API Gateway → Lambda)
- `aws_cloudwatch_log_group` (API Gateway Logs)

## Inputs
| Variable                  | Description                                         | Type    | Default  |
|---------------------------|-----------------------------------------------------|---------|----------|
| `project`                 | Project name                                        | string  | `"aws-lambda-translate"` |
| `environment`             | Deployment environment (e.g., `dev`, `prod`)       | string  | **Required** |
| `region`                  | AWS region to deploy the API Gateway               | string  | **Required** |
| `lambda_function_invoke_arn` | ARN of the Lambda function for integration     | string  | **Required** |
| `lambda_function_name`    | Name of the Lambda function                        | string  | **Required** |
| `kms_key_id`              | KMS Key for encrypting CloudWatch logs             | string  | **Required** |

## Outputs
| Output                  | Description                                          |
|-------------------------|------------------------------------------------------|
| `api_gateway_id`        | The ID of the API Gateway                            |
| `api_gateway_endpoint`  | The base URL for API requests                        |

## Usage Example
```hcl
module "api_gateway" {
  source = "./modules/api_gateway"

  project                  = "aws-lambda-translate"
  environment              = "dev"
  region                   = "us-east-1"
  lambda_function_invoke_arn = module.lambda.lambda_function_arn
  lambda_function_name     = module.lambda.lambda_function_name
  kms_key_id               = module.kms.kms_key_id
}
