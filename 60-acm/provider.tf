terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.28.0"
    }
  }
  backend "s3" {
    bucket         = "expense-dev-infra-girisha"
    key            = "expense-dev-acm"
    region         = "us-east-1"
    dynamodb_table = "giri-bucket-lock"

  }
}

provider "aws" {
  # Configuration optionss
  region = "us-east-1"
}
