terraform {
  required_version = "~>0.14.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
    mysql = {
      source  = "terraform-providers/mysql"
      version = "~> 1.9"
    }
  }

  backend "local" {
    path = "../${env}-terraform.tfstate"
  }
}

provider "aws" {
  region = "${aws_region}"
}
