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

  backend "s3" {
    bucket = "${bucket_provisioning_id}"
    key    = "provisioning/terraform/${env}-${project}.tfstate"
    region = "${aws_region}"
  }
}

provider "aws" {
  region = "${aws_region}"
}
