module "security_group" {
  source            = "./modules/security_group"
  env               = var.env
  project           = var.project
  vpc_id            = local.vpc_id
  rds_port          = 3306
  webapp_subnet_ids = local.webapp_subnet_ids
  sg_operation_server_id = local.operation_server.security_group_id
}

module "log_group" {
  source  = "./modules/log_group"
  env     = var.env
  project = var.project
}

module "alb" {
  source = "./modules/alb"

  env                         = var.env
  project                     = var.project
  hosted_zone_id              = var.hosted_zone_id
  hosted_zone_name            = var.hosted_zone_name
  vpc_id                      = local.vpc_id
  subdomain_csweb             = var.subdomain_csweb
  csweb_app_health_check_path = var.csweb_app_health_check_path
  public_subnet_ids           = local.public_subnet_ids
  sg_alb_csweb_ids            = [module.security_group.alb_csweb_id]
}

module "ecs" {
  source = "./modules/ecs"

  env                        = var.env
  project                    = var.project
  webapp_subnet_ids          = local.webapp_subnet_ids
  sg_ecs_csweb_ids           = [module.security_group.ecs_csweb_id]
  csweb_app_repository_url   = local.ecr_csweb_app.repository_url
  alb_target_group_csweb_arn = module.alb.target_group_csweb_arn
  log_group_ecs_csweb_app    = module.log_group.ecs_csweb_app
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
