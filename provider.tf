# Terraform Block
terraform {
  required_version = ">= 1.0" # which means any version equal & above 0.14 like 0.15, 0.16 etc and < 1.xx
  backend "s3" {
    # Replace this with your bucket name!
    bucket         = "kmbl-build-uat-tfstate"
    key            = "kmbl-projecta-ec2-260423-uat/terraform.tfstate"
    region         = "ap-south-1"

    # Replace this with your DynamoDB table name!
    dynamodb_table = "kmbl-projecta-ec2-260423-uat"
    encrypt        = false
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Provider Block
provider "aws" {
  region  = var.kmbl_region
}

