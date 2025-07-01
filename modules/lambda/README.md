# ⚡ Lambda Translation Module

## Overview
This module creates an AWS Lambda function that processes translation requests using AWS Translate service. The function handles HTTP requests from API Gateway, translates text between supported languages, and stores request/response data in S3 buckets.

## 🏗️ Architecture
- **Runtime**: Python 3.12
- **Memory**: 128 MB (cost-optimized)
- **Handler**: `lambda_translate.lambda_handler`
- **Integration**: API Gateway proxy integration
- **Storage**: S3 buckets for request/response logging
- **Encryption**: KMS encryption for environment variables
- **Monitoring**: CloudWatch Logs and X-Ray tracing

## 📦 Resources Created
- `aws_lambda_function` - Main translation function
- `aws_iam_role` - Lambda execution role
- `aws_iam_role_policy_attachment` - Basic execution policy
- `aws_iam_policy` - Custom policy for S3 and Translate access
- `aws_cloudwatch_log_group` - Function logs with KMS encryption
- `data.archive_file` - ZIP package of function code

## 🌍 Supported Languages
- English (en) ↔ Spanish (es)
- English (en) ↔ French (fr)
- English (en) ↔ German (de)
- English (en) ↔ Chinese (zh)
- English (en) ↔ Japanese (ja)
- English (en) ↔ Korean (ko)
- English (en) ↔ Portuguese (pt)
- English (en) ↔ Italian (it)
- English (en) ↔ Russian (ru)

## 📋 Variables

| Variable | Type | Description |
|----------|------|-------------|
| `function_name` | `string` | Name of the Lambda function |
| `function_handler` | `string` | Function handler (lambda_translate.lambda_handler) |
| `request_bucket` | `string` | S3 bucket name for storing requests |
| `response_bucket` | `string` | S3 bucket name for storing responses |
| `request_bucket_arn` | `string` | ARN of the request S3 bucket |
| `response_bucket_arn` | `string` | ARN of the response S3 bucket |
| `request_bucket_name` | `string` | Name of the request bucket (alternative) |
| `response_bucket_name` | `string` | Name of the response bucket (alternative) |
| `kms_key_id` | `string` | KMS key ID for encryption |
| `project` | `string` | Project name for tagging |
| `environment` | `string` | Environment name (dev, staging, production) |
| `region` | `string` | AWS region for deployment |
| `tags` | `map(string)` | Additional resource tags |

## 📤 Outputs

| Output | Description |
|--------|-------------|
| `function_arn` | ARN of the Lambda function |
| `function_name` | Name of the Lambda function |
| `function_invoke_arn` | Invoke ARN for API Gateway integration |
| `lambda_invoke_arn` | Alternative invoke ARN output |

## 🚀 Usage

```hcl
module "lambda" {
  source               = "./modules/lambda"
  function_name        = "translation-lambda"
  function_handler     = "lambda_translate.lambda_handler"
  request_bucket       = module.request_bucket.bucket_name
  response_bucket      = module.response_bucket.bucket_name
  request_bucket_arn   = module.request_bucket.bucket_arn
  response_bucket_arn  = module.response_bucket.bucket_arn
  kms_key_id           = module.kms_key.key_arn
  project              = "aws-translate"
  environment          = "production"
  region               = "us-east-1"
  tags = {
    CreatedBy = "Samuel Adusei Boateng"
  }
}
```

## � Function Behavior

### Input Format
```json
{
  "httpMethod": "POST",
  "body": "{\"source_language\": \"en\", \"target_language\": \"es\", \"text\": \"Hello world\"}"
}
```

### Output Format
```json
{
  "statusCode": 200,
  "headers": {
    "Content-Type": "application/json",
    "Access-Control-Allow-Origin": "*"
  },
  "body": "{\"original_text\": \"Hello world\", \"translated_text\": \"Hola mundo\", \"source_language\": \"en\", \"target_language\": \"es\"}"
}
```

## 🔒 Security Features
- **IAM Role**: Least-privilege permissions for S3 and Translate
- **KMS Encryption**: Environment variables encrypted at rest
- **VPC**: Runs in AWS-managed VPC for security
- **X-Ray Tracing**: Enabled for performance monitoring

## 📊 Monitoring
- **CloudWatch Logs**: Function execution logs with 1-day retention
- **X-Ray Tracing**: Request tracing for debugging
- **Metrics**: Lambda invocation, duration, and error metrics

## 💰 Cost Optimization
- **Memory**: 128 MB (minimum required)
- **Timeout**: 30 seconds (sufficient for translation)
- **Log Retention**: 1 day (cost-effective)
- **Architecture**: x86_64 for cost efficiency

## 📝 Notes
- Function code is packaged as `lambda_translate.zip`
- Environment variables: `REQUEST_BUCKET` and `RESPONSE_BUCKET`
- Supports both `request_bucket` and `request_bucket_name` variables for flexibility
- Function automatically creates S3 objects for audit trail