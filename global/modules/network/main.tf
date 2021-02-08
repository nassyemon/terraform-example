module "vpc" {
  source = "../vpc"

  aws_vpc_cidr = var.aws_vpc_cidr
  aws_vpc_tags_name = var.aws_vpc_tags_name
  network_env = var.network_env
}

module "webapp_subnet" {
  source = "../subnet"

  name               = "webapp-subnet"
  network_env        = var.network_env
  vpc_id             = module.vpc.id
  cidrs              = var.webapp_subnet_cidrs
  availability_zones = var.availability_zones
}

module "database_subnet" {
  source = "../subnet"

  name               = "database-subnet"
  network_env        = var.network_env
  vpc_id             = module.vpc.id
  cidrs              = var.database_subnet_cidrs
  availability_zones = var.availability_zones
}

module "public_subnet" {
  source = "../subnet"

  name               = "public-subnet"
  network_env        = var.network_env
  vpc_id             = module.vpc.id
  cidrs              = var.public_subnet_cidrs
  availability_zones = var.availability_zones
}