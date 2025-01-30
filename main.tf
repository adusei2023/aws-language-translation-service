module "lambda" {
  source              = "./modules/lambda"
  lambda_function_name = "translate_lambda"
  lambda_role_arn     = module.iam.lambda_role_arn
  s3_requests_bucket  = module.s3.requests_bucket_name
  s3_responses_bucket = module.s3.responses_bucket_name
}
