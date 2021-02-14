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

provider "aws" {
  region = var.aws_region
}

module "production_network" {
  source = "./modules/network"
  aws_vpc_cidr = var.aws_vpc_cidr_prd
  aws_vpc_tags_name = var.aws_vpc_tags_name
  availability_zones = var.availability_zones
  webapp_subnet_cidrs = var.webapp_subnet_cidrs_prd
  database_subnet_cidrs = var.database_subnet_cidrs_prd
  public_subnet_cidrs = var.public_subnet_cidrs_prd
  destination_cidr_block = var.destination_cidr_block
  network_env = "prd"
}