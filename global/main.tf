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

module "production_operation_server" {
  source                   = "./modules/operation_server"
  network_env              = "prd"
  vpc_id                   = module.production_network.vpc_id
  aws_vpc_cidr             = var.aws_vpc_cidr_prd
  public_subnet_id         = module.production_network.public_subnet_ids[0]
  operator_users           = var.external_operator_users_prd # TODO
  os_username              = var.operation_server_username
}

module "ecr" {
  source                    = "./modules/ecr"
  csweb_app_repository_name = var.csweb_app_repository_name
}
