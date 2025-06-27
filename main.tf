# ---------------------------------------------------------------------------------------------------------------------
# TERRAFORM CONFIGURATION
# ---------------------------------------------------------------------------------------------------------------------
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# AWS PROVIDER CONFIGURATION - US-EAST-1
# ---------------------------------------------------------------------------------------------------------------------
provider "aws" {
  region = "us-east-1"
}

# ---------------------------------------------------------------------------------------------------------------------
# KMS KEY MODULE
# ---------------------------------------------------------------------------------------------------------------------
module "kms_key" {
  source      = "./modules/kms"
  project     = var.project
  environment = var.environment
  tags        = var.tags
  region      = "us-east-1"
  key_users   = ["arn:aws:iam::061039790475:role/aws-translate-production-LambdaRole"]
  key_owners  = ["arn:aws:iam::061039790475:root"]
  key_admins  = ["arn:aws:iam::061039790475:root"]
  aliases     = ["alias/${var.project}-key"]
  kms_vars = {
    description = "KMS key for language translation service"
    deletion_window_in_days = 7
    enable_key_rotation = true
    key_usage = "ENCRYPT_DECRYPT"
    customer_master_key_spec = "SYMMETRIC_DEFAULT"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# S3 BUCKETS
# ---------------------------------------------------------------------------------------------------------------------
module "request_bucket" {
  source                = "./modules/s3"
  bucket_name           = var.request_bucket
  kms_key_id            = module.kms_key.key_arn
  tags                  = var.tags
  project               = var.project
  environment           = var.environment
  region                = "us-east-1"
  bucket_policy_actions = var.request_bucket_policy_actions
}

module "response_bucket" {
  source                = "./modules/s3"
  bucket_name           = var.response_bucket
  kms_key_id            = module.kms_key.key_arn
  tags                  = var.tags
  project               = var.project
  environment           = var.environment
  region                = "us-east-1"
  bucket_policy_actions = var.response_bucket_policy_actions
}

# ---------------------------------------------------------------------------------------------------------------------
# LAMBDA FUNCTION
# ---------------------------------------------------------------------------------------------------------------------
module "lambda" {
  source                = "./modules/lambda"
  function_name         = "translation-lambda"
  kms_key_id            = module.kms_key.key_arn
  tags                  = var.tags
  project               = var.project
  environment           = var.environment
  region                = "us-east-1"
  function_handler      = "index.handler"
  request_bucket        = module.request_bucket.bucket_name
  request_bucket_name   = module.request_bucket.bucket_name
  request_bucket_arn    = module.request_bucket.bucket_arn
  response_bucket       = module.response_bucket.bucket_name
  response_bucket_name  = module.response_bucket.bucket_name
  response_bucket_arn   = module.response_bucket.bucket_arn
}

# ---------------------------------------------------------------------------------------------------------------------
# API GATEWAY
# ---------------------------------------------------------------------------------------------------------------------
module "api_gateway" {
  source                  = "./modules/api_gateway"
  project                 = var.project
  environment             = var.environment
  region                  = "us-east-1"
  tags                    = var.tags
  kms_key_id              = module.kms_key.key_arn
  api_gateway_route       = "/translate"
  api_gateway_method      = "POST"
  lambdaFunctionName      = module.lambda.function_name
  lambaFunctionInvokeArn  = module.lambda.lambda_invoke_arn
}

# ---------------------------------------------------------------------------------------------------------------------
# FRONTEND
# ---------------------------------------------------------------------------------------------------------------------
module "frontend" {
  source           = "./modules/frontend"
  bucket_name      = "${var.project}-frontend-${var.environment}"
  project          = var.project
  environment      = var.environment
  api_gateway_url  = module.api_gateway.api_gateway_endpoint
  tags             = var.tags
}
