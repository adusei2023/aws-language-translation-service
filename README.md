# AWS Language Translation Service

This project deploys a serverless language translation service on AWS using Terraform Infrastructure as Code (IaC).

## Architecture

- **Lambda Function**: Processes translation requests using AWS Translate
- **API Gateway**: REST API endpoint for translation requests  
- **S3 Buckets**: Storage for requests and responses
- **KMS**: Encryption for data at rest
- **CloudWatch**: Logging and monitoring

## Prerequisites

- AWS CLI configured with appropriate permissions
- Terraform >= 1.0
- Python 3.8+

## Deployment

1. Clone the repository:
   ```bash
   git clone https://github.com/YOUR_USERNAME/aws-language-translation-service.git
   cd aws-language-translation-service
   ```
2. Create a `terraform.tfvars` file for variable configuration. Refer to `terraform.tfvars.example` for guidance.
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your specific values
   ```
3. Initialize Terraform:
   ```bash
   terraform init -backend-config=backend.tfvars
   ```
4. Review the execution plan:
   ```bash
   terraform plan
   ```
5. Apply the changes:
   ```bash
   terraform apply
   ```
6. Note the API Gateway endpoint URL from the output.



## Usage

- Send a POST request to the API Gateway endpoint with a JSON body containing the text and target language.
- The Lambda function will process the request, translate the text, and store the result in the specified S3 bucket.
- Retrieve the translated text from the S3 bucket or via the API Gateway GET endpoint.

## Cleanup

To avoid ongoing charges to your AWS account, delete the resources provisioned by Terraform:

```bash
terraform destroy
```

## Security Considerations

- IAM Role Least Privilege: The Lambda function and API Gateway have restricted permissions.
- S3 Bucket Encryption: All S3 objects are encrypted using AWS KMS.
- API Gateway Authorization: The API is protected via IAM authentication.
- Terraform State Security: State files are stored in an S3 backend with DynamoDB locking.
- Public Access Blocking: S3 buckets have public access blocked

## Troubleshooting

- Check CloudWatch logs for Lambda function errors.
- Ensure the API Gateway is correctly integrated with the Lambda function.
- Verify S3 bucket policies and permissions.
- Validate AWS Translate service limits and supported language pairs.
- Check IAM permissions for Lambda execution role.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any enhancements or bug fixes.



Usage
Send POST requests to the API Gateway endpoint:

{
  "source_language": "en",
  "target_language": "es",
  "text": "Hello world. This is a test translation."
}
## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

AWS Language Translation Service

├── main.tf                 # Main Terraform configuration
├── variables.tf           # Variable definitions
├── outputs.tf            # Output definitions
├── terraform.tfvars      # Variable values (not in repo)
├── backend.tfvars        # Backend config (not in repo)
├── modules/
│   ├── lambda/           # Lambda function module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── iam.tf
│   │   ├── data.tf
│   │   └── lambda_translate.py
│   ├── s3/              # S3 buckets module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── data.tf
│   ├── kms/             # KMS encryption module
│   └── api_gateway/     # API Gateway module
└── README.md


Testing
Test the translation service using:

AWS Lambda Console (Test button)
API Gateway Test Console
cURL commands
Postman or other API testing tools
Security Considerations
IAM Role Least Privilege: The Lambda function and API Gateway have restricted permissions
S3 Bucket Encryption: All S3 objects are encrypted using AWS KMS
API Gateway Authorization: The API is protected via IAM authentication
Terraform State Security: State files are stored in an S3 backend with DynamoDB locking
Public Access Blocking: S3 buckets have public access blocked

Cost Optimization
Lambda function uses minimal memory allocation
S3 lifecycle policies for log retention
Pay-per-use pricing model
KMS key rotation enabled
Cleanup
To avoid ongoing charges to your AWS account, delete the resources provisioned by Terraform:

terraform destroy


Troubleshooting

Check CloudWatch logs for Lambda function errors
Ensure the API Gateway is correctly integrated with the Lambda function
Verify S3 bucket policies and permissions
Validate AWS Translate service limits and supported language pairs
Check IAM permissions for Lambda execution role

Contributing
Contributions are welcome! Please open an issue or submit a pull request for any enhancements or bug fixes.

CloudFormation Group Members
Samuel Adusei Boateng - Project Lead & AWS Infrastructure Developer
LinkedIn: https://www.linkedin.com/in/samueladuseiboateng/
Role: Terraform Infrastructure, Lambda Development, API Gateway Configuration
Note: Add additional members here

## Commit and Push the Changes

```bash
# Add the updated README
git add README.md

# Commit the changes
git commit -m "Update README with comprehensive documentation and CloudFormation group information

- Added detailed project structure and usage examples
- Included CloudFormation group members section
- Enhanced security considerations and troubleshooting guide
- Added supported languages and testing instructions
- Included author attribution and acknowledgments"

# Push to GitHub
git push origin master
```