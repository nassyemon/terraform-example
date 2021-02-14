
terraform {
  required_version = "=0.14.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
  }
}

data "terraform_remote_state" "global" {
  backend = "s3"

  config = {
    bucket = var.global_be_bucket
    key    = var.global_be_key
    region = var.global_be_region
  }
}

locals {
  network = (
    var.network_env == "production_network" ?
      data.terraform_remote_state.global.outputs.production_network
    : data.terraform_remote_state.global.outputs.development_network
  )
  public_subnet_ids = local.network.public_subnet_ids
  webapp_subnet_ids = local.network.webapp_subnet_ids
  database_subnet_ids = local.network.database_subnet_ids
}

provider "aws" {
  region = var.aws_region
}
