# Backend Configuration for Remote State Storage
# Stores Terraform state file in an S3 bucket with DynamoDB for state locking

bucket         = "proj-tfstate"             # S3 bucket to store Terraform state
key            = "translate/terraform.tfstate"  # Path within the bucket for the state file
region         = "eu-west-1"                # AWS region for backend storage
dynamodb_table = "terraform"                # DynamoDB table for state locking
