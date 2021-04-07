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
  source           = "./modules/operation_server"
  network_env      = "prd"
  aws_region       = var.aws_region
  vpc_id           = module.production_network.vpc_id
  aws_vpc_cidr     = var.aws_vpc_cidr_prd
  public_subnet_id = module.production_network.public_subnet_ids[0]
  operator_users   = var.external_operator_users_prd # TODO
  os_username      = var.operation_server_username
}

module "ecr" {
  source                       = "./modules/ecr"
  csweb_app_repository_name    = var.csweb_app_repository_name
  csweb_nginx_repository_name  = var.csweb_nginx_repository_name
  admweb_app_repository_name   = var.admweb_app_repository_name
  admweb_nginx_repository_name = var.admweb_nginx_repository_name
  migrate_app_repository_name  = var.migrate_app_repository_name
}

module "ses" {
  source                    = "./modules/ses"
  aws_region                = var.aws_region
  hosted_zone_name          = var.hosted_zone_name
  hosted_zone_id            = var.hosted_zone_id
  developer_email_addresses = var.developer_email_addresses
  # cognito_email_address     = var.cognito_email_address_local_development
}

module "cognito_local_development_csweb" {
  source  = "./modules/cognito_csweb"
  project = var.project
  env     = "local-development"
  # email_address      = var.cognito_email_address_local_development
  # email_display_name = var.cognito_email_display_name_local_development
  # email_idnetity_arn = module.ses.cognitio_email_identity_arn

  # depends_on = [module.ses]
}