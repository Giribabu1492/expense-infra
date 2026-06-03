terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.28.0"
    }
  }
  backend "s3" {
    bucket         = "expense-dev-infra-shrihan"
    key            = "expense-dev-bastion"
    region         = "us-east-1"
    dynamodb_table = "giri-bucket-lock"

  }
}

provider "aws" {
  # Configuration optionss
  region = "us-east-1"
}
