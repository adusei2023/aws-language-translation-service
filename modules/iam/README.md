# IAM Module

This module creates an IAM role with the necessary permissions for the Lambda function.

## Permissions Granted:
- **S3 Access**: Allows the Lambda function to read and write translation requests and responses.
- **AWS Translate**: Grants the Lambda function permission to use AWS Translate.

## Outputs:
- `lambda_role_arn`: The ARN of the IAM role assigned to the Lambda function.
