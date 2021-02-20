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
  ecr_csweb_app          = data.terraform_remote_state.global.outputs.ecr_csweb_app
  vpc_id              = local.network.vpc_id
  public_subnet_ids   = local.network.public_subnet_ids
  webapp_subnet_ids   = local.network.webapp_subnet_ids
  database_subnet_ids = local.network.database_subnet_ids
}

module "security_group" {
  source   = "./modules/security_group"
  env      = var.env
  project  = var.project
  vpc_id   = local.vpc_id
  rds_port = 3306
  webapp_subnet_ids      = local.webapp_subnet_ids
}

module "log_group" {
  source   = "./modules/log_group"
  env      = var.env
  project  = var.project
}

module "alb" {
  source = "./modules/alb"

  env                    = var.env
  project                = var.project
  hosted_zone_id         = var.hosted_zone_id
  hosted_zone_name       = var.hosted_zone_name
  vpc_id   = local.vpc_id
  subdomain_csweb = var.subdomain_csweb
  csweb_app_health_check_path      = var.csweb_app_health_check_path
  public_subnet_ids      = local.public_subnet_ids
  sg_alb_csweb_ids    = [module.security_group.alb_csweb_id]
}

module "ecs" {
  source = "./modules/ecs"

  env                    = var.env
  project                = var.project
  webapp_subnet_ids      = local.webapp_subnet_ids
  sg_ecs_csweb_ids          = [module.security_group.ecs_csweb_id]
  csweb_app_repository_url  = local.ecr_csweb_app.repository_url
  alb_target_group_csweb_arn = module.alb.target_group_csweb_arn
  log_group_ecs_csweb_app   = module.log_group.ecs_csweb_app
}

module "rds" {
  source = "./modules/rds"

  env                    = var.env
  project                = var.project
  name                   = var.rds_name
  database_subnet_ids    = local.network.database_subnet_ids
  rds_security_group_ids = [module.security_group.rds_id]
  port                   = 3306
  username               = var.rds_username
  instance_class         = var.rds_instance_params.instance_class
  allocated_storage      = var.rds_instance_params.allocated_storage
  storage_class          = var.rds_instance_params.storage_class
  multi_az               = var.rds_instance_params.multi_az
  backup_window          = var.rds_instance_params.backup_window
  maintenance_window     = var.rds_instance_params.maintenance_window

  disabled = var.disabled
}

module "operation_server" {
  source = "./modules/operation_server"
  env                    = var.env
  project                = var.project
  public_subnet_id = local.network.public_subnet_ids[0]
  sg_operation_server_ids = [module.security_group.operation_server_id]
  operator_users = var.external_operator_users # TODO
}
