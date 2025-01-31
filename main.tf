# Provider Configuration
provider "aws" {
  region = var.aws_region
}

# S3 Module - Creates an S3 bucket for storing translation input files
module "s3" {
  source      = "./modules/s3"
  bucket_name = var.s3_bucket_name
}

# IAM Module - Creates an IAM role for Lambda execution
module "iam" {
  source = "./modules/iam"
}

# Lambda Module - Deploys the function that performs translations
module "lambda" {
  source          = "./modules/lambda"
  lambda_name     = var.lambda_name
  lambda_role_arn = module.iam.lambda_role_arn
  s3_bucket_name  = module.s3.bucket_name
}

# API Gateway Module - Exposes the Lambda function via an HTTP endpoint
module "api_gateway" {
  source           = "./modules/api_gateway"
  lambda_invoke_arn = module.lambda.lambda_invoke_arn
}
