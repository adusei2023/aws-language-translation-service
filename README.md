# Automated Language Translation Service

This project automates the process of language translation using AWS services, leveraging **API Gateway**, **Lambda**, **S3**, and **AWS Translate**. It takes a JSON file containing multiple sentences in a specific language, translates it into another language using **AWS Translate**, and stores the request and response files in designated S3 buckets.

---

## **Project Overview**
The architecture is designed to be scalable, serverless, and efficient. It includes:
1. **API Gateway**: Provides a secure endpoint for users to upload translation requests and retrieve results.
2. **Lambda**: Executes the translation logic using a Python script integrated with **Boto3**.
3. **S3**: 
   - Stores translation requests and responses.
   - Serves as a logging mechanism for tracking input and output files.
4. **AWS Translate**: Performs the language translation.

---

## **Architecture**
![Architecture Diagram](assets/project_architecture.png)

1. Users upload JSON files containing text to be translated via API Gateway.
2. The request is routed to a Lambda function.
3. The Lambda function:
   - Fetches the input JSON file from the S3 bucket.
   - Processes it using AWS Translate.
   - Stores the translated output back in the designated S3 bucket.
4. API Gateway provides the endpoint for interacting with the service.

---

## **Features**
- **Serverless Architecture**: Fully managed by AWS services, ensuring high availability and scalability.
- **Automated Language Translation**: Supports multiple languages using AWS Translate.
- **Secure Data Storage**: Uses IAM roles and policies to secure S3 buckets and other resources.

---

## **Prerequisites**
1. AWS account with access to:
   - **API Gateway**
   - **Lambda**
   - **S3**
   - **AWS Translate**
2. Terraform installed on your local machine.

---

## **Deployment**
Follow these steps to deploy the project infrastructure:

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/language-translation-aws-iac-solution.git
   cd aws-translate-service
