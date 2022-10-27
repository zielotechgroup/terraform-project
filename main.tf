terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.34.0"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block       = "199.199.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}
