# Provider Configuration
#provider "aws" {
# region = var.aws_region
#}

# S3 Module - Creates an S3 bucket for storing translation input files
module "s3" {
  source                = "./modules/s3"
  requests_bucket_name  = var.s3_requests_bucket
  responses_bucket_name = var.s3_responses_bucket
}

# IAM Module - Creates an IAM role for Lambda execution
module "iam" {
  source               = "./modules/iam"
  requests_bucket_arn  = module.s3.s3_requests_bucket_arn
  responses_bucket_arn = module.s3.s3_responses_bucket_arn
}

# Lambda Module - Deploys the function that performs translations
module "lambda" {
  source               = "./modules/lambda"
  lambda_function_name = var.lambda_name
  lambda_role_arn      = module.iam.lambda_role_arn
  s3_requests_bucket   = module.s3.s3_requests_bucket
  s3_responses_bucket  = module.s3.s3_responses_bucket
}

# API Gateway Module - Exposes the Lambda function via an HTTP endpoint
module "api_gateway" {
  source            = "./modules/api_gateway"
  lambda_invoke_arn = module.lambda.lambda_invoke_arn
}
