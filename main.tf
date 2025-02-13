# ===========================
#   Infrastructure Modules
# ===========================

# S3 Bucket Module for storing translation requests
module "translation_request_bucket" {
  source                = "./modules/s3"
  bucket_name           = var.translation_request_bucket
  kms_key_id            = module.kms_encryption.key_arn
  tags                  = var.tags
  project               = var.project
  environment           = var.environment
  region                = var.region
  bucket_policy_actions = var.request_bucket_policy_actions
}

# S3 Bucket Module for storing translation responses
module "translation_response_bucket" {
  source                = "./modules/s3"
  bucket_name           = var.translation_response_bucket
  kms_key_id            = module.kms_encryption.key_arn
  tags                  = var.tags
  project               = var.project
  environment           = var.environment
  region                = var.region
  bucket_policy_actions = var.response_bucket_policy_actions
}

# AWS Lambda Module - Deploys the function responsible for performing translations
module "translation_lambda" {
  source              = "./modules/lambda"
  function_name       = var.lambda_function_name
  function_handler    = var.lambda_function_handler
  request_bucket      = module.translation_request_bucket.bucket_name
  response_bucket     = module.translation_response_bucket.bucket_name
  request_bucket_arn  = module.translation_request_bucket.bucket_arn
  response_bucket_arn = module.translation_response_bucket.bucket_arn
  tags                = var.tags
  project             = var.project
  environment         = var.environment
  region              = var.region
  kms_key_id          = module.kms_encryption.key_arn
}

# AWS KMS Module - Creates a key for encrypting data across S3 and Lambda
module "kms_encryption" {
  source      = "./modules/kms"
  tags        = var.tags
  project     = var.project
  environment = var.environment
  region      = var.region
  kms_vars    = var.kms_settings
  aliases     = var.kms_aliases
  key_owners  = var.kms_key_owners
  key_admins  = var.kms_key_admins
  key_users   = var.kms_key_users
}

# API Gateway Module - Creates an endpoint for invoking the Lambda function
module "translation_api_gateway" {
  source                 = "./modules/api_gateway"
  tags                   = var.tags
  project                = var.project
  environment            = var.environment
  region                 = var.region
  lambda_function_invoke_arn = module.translation_lambda.function_invoke_arn
  lambda_function_name       = module.translation_lambda.function_name
  kms_key_id             = module.kms_encryption.key_arn
}
