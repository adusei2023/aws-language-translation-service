# API Gateway Variables

variable "api_name" {
  description = "The name of the API Gateway"
  type        = string
  default     = "TranslateAPI"
}

variable "api_description" {
  description = "A brief description of the API"
  type        = string
  default     = "API Gateway for the translation service"
}

variable "lambda_invoke_arn" {
  description = "The invoke ARN of the Lambda function"
  type        = string
}
