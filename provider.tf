# ===========================
#   Terraform Provider
# ===========================

terraform {
  required_version = ">= 1.10.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.84.0"
    }
  }

  # Remote backend for storing Terraform state
  backend "s3" {
    
  }
}

# AWS Provider Configuration
provider "aws" {
  region = "eu-west-1"

  # Global default tags for all AWS resources
  default_tags {
    tags = {
      Project     = var.project
      Environment = var.environment
      Region      = var.region
      ManagedBy   = "Terraform"
    }
  }
}
