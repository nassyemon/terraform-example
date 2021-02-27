# sg
module "security_group" {
  source                 = "./modules/security_group"
  env                    = var.env
  project                = var.project
  vpc_id                 = local.vpc_id
  rds_port               = 3306
  webapp_subnet_ids      = local.webapp_subnet_ids
  csweb_alb_ingress_cidrs = var.csweb_alb_ingress_cidrs
  admweb_alb_ingress_cidrs = var.admweb_alb_ingress_cidrs
  sg_operation_server_id = local.operation_server.security_group_id
}

# log
module "log_group" {
  source  = "./modules/log_group"
  env     = var.env
  project = var.project
}

# s3
module "s3" {
  source  = "./modules/s3"
  env     = var.env
  project = var.project
}

# iam
module "iam" {
  source  = "./modules/iam"
  env     = var.env
  project = var.project
}

# rds
module "rds" {
  source = "./modules/rds"

  env                    = var.env
  project                = var.project
  ssm_base_path          = local.ssm_base_path
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

# alb
module "alb_csweb" {
  source = "./modules/alb"

  env               = var.env
  project           = var.project
  hosted_zone_id    = var.hosted_zone_id
  hosted_zone_name  = var.hosted_zone_name
  vpc_id            = local.vpc_id
  subdomain         = var.csweb_subdomain
  health_check_path = var.csweb_health_check_path
  subnet_ids        = local.public_subnet_ids
  sg_alb_ids        = [module.security_group.alb_csweb_id]
  listen_http       = true
  redirect_https    = true
  internal          = false
}

module "alb_admweb" {
  source = "./modules/alb"

  env               = var.env
  project           = var.project
  hosted_zone_id    = var.hosted_zone_id
  hosted_zone_name  = var.hosted_zone_name
  vpc_id            = local.vpc_id
  subdomain         = var.admweb_subdomain
  health_check_path = var.admweb_health_check_path
  subnet_ids        = local.public_subnet_ids
  sg_alb_ids        = [module.security_group.alb_admweb_id]
  listen_http       = false
  redirect_https    = false
  internal          = false
}

# ecs
module "ecs_service_csweb" {
  source = "./modules/ecs_service"

  env                        = var.env
  project                    = var.project
  service_name               = "csweb"
  webapp_subnet_ids          = local.webapp_subnet_ids
  sg_ecs_ids                 = [module.security_group.ecs_csweb_id]
  iam_ecs_task_role_arn      = module.iam.ecs_task_role_arn
  iam_ecs_execution_role_arn = module.iam.ecs_execiton_role_arn
  app_repository_url         = local.ecr_csweb.app_repository_url
  nginx_repository_url       = local.ecr_csweb.nginx_repository_url
  alb_target_group_arn       = module.alb_csweb.target_group_arn
  log_group_app_name         = module.log_group.ecs_service_csweb.app_name
  log_group_nginx_name       = module.log_group.ecs_service_csweb.nginx_name
  task_definition_yml        = "csweb.yaml"

  depends_on                 = [module.alb_csweb. module.operation_server]
}

module "ecs_service_admweb" {
  source = "./modules/ecs_service"

  env                        = var.env
  project                    = var.project
  service_name               = "admweb"
  webapp_subnet_ids          = local.webapp_subnet_ids
  sg_ecs_ids                 = [module.security_group.ecs_admweb_id]
  iam_ecs_task_role_arn      = module.iam.ecs_task_role_arn
  iam_ecs_execution_role_arn = module.iam.ecs_execiton_role_arn
  app_repository_url         = local.ecr_admweb.app_repository_url
  nginx_repository_url       = local.ecr_admweb.nginx_repository_url
  alb_target_group_arn       = module.alb_admweb.target_group_arn
  log_group_app_name         = module.log_group.ecs_service_admweb.app_name
  log_group_nginx_name       = module.log_group.ecs_service_admweb.nginx_name
  task_definition_yml        = "admweb.yaml"

  depends_on                 = [module.alb_admweb, module.operation_server]
}

# operation server provisioning.
module "operation_server" {
  source                     = "./modules/operation_server"
  env                        = var.env
  project                    = var.project
  ssm_base_path              = local.ssm_base_path
  iam_role_id                = local.operation_server.iam_role_id
  s3_bucket_provisioning     = module.s3.bucket_provisioning
  os_username                = local.operation_server_username
  instance_id                = local.operation_server.instance_id
  rds_identifier             = module.rds.identifier
  rds_endpoint               = module.rds.endpoint
  rds_username               = module.rds.username
  rds_password_secrets_arn   = module.rds.password_secrets_arn
  rds_appdb_username         = var.rds_appdb_username
  rds_appdb_name             = var.rds_appdb_name

  depends_on                 = [module.s3, module.rds]
}