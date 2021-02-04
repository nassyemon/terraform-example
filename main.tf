
terraform {
  required_version = "=0.14.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.aws_vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "false"

  tags = {
    Name = var.aws_vpc_tags_name
  }
}

output "vpc-id" {
  value = aws_vpc.vpc.arn
}
