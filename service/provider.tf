terraform {
  required_version = "=0.14.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.1"
    }

    template = {
      source  = "hashicorp/template"
      version = "~> 2.2"
    }

    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.1"
    }
  }

  backend "s3" {
  }
}

provider "aws" {
  region = var.aws_region
}
