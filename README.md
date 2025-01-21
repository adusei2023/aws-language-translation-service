# AWS Translation Automation with Terraform

## Overview

This project demonstrates an automated language translation pipeline leveraging AWS Translate, Amazon S3, and AWS Lambda, with infrastructure managed via Terraform. The solution processes translation requests from an input JSON file, performs language translations using AWS Translate, and stores the translated output in Amazon S3.

The project emphasizes a scalable and modular design for real-world applications, integrating Infrastructure-as-Code (IaC) principles to ensure consistent and reliable deployments.

##  Features

- Automated Translation: Utilize AWS Translate for seamless language conversion..
- Serverless Architecture: Powered by AWS Lambda to minimize operational overhead.
- Secure and Scalable Storage: Amazon S3 handles input, output, and logging for translation tasks.
- Infrastructure-as-Code (IaC): Deploy resources consistently with Terraform.
- Cloud-Native Automation: Python with Boto3 integrates the application logic and AWS SDK.
- IAM roles for securely accessing AWS Translate and S3.

## Architecture

The architecture follows a serverless-first design, incorporating:
- Amazon S3: Stores translation requests (input) and responses (output).
- AWS Lambda: Executes the Python script (lambda_translate.py) for translation logic.
- AWS Translate: Processes language translation requests.
- IAM Roles: Ensures secure access between AWS services.

For a visual representation, refer to the assets/architecture-diagram.png file in this repository.

## Getting Started

### Prerequisites
- An AWS account with appropriate permissions.
- Terraform installed locally.
- Python 3.8+ installed for Lambda development.
- AWS CLI installed and configured.
- Access keys or role-based credentials for AWS SDK (Boto3).
