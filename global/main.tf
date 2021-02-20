module "production_network" {
  source                 = "./modules/network"
  aws_vpc_cidr           = var.aws_vpc_cidr_prd
  aws_vpc_tags_name      = var.aws_vpc_tags_name
  availability_zones     = var.availability_zones
  webapp_subnet_cidrs    = var.webapp_subnet_cidrs_prd
  database_subnet_cidrs  = var.database_subnet_cidrs_prd
  public_subnet_cidrs    = var.public_subnet_cidrs_prd
  destination_cidr_block = var.destination_cidr_block
  disabled               = var.disabled
  network_env            = "prd"
  use_single_nat_gateway = true
}

module "ecr" {
  source                 = "./modules/ecr"
  csweb_app_repository_name = var.csweb_app_repository_name
}
