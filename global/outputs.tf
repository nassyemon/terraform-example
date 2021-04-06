locals {
  production_network           = module.production_network
  development_network          = module.production_network
  production_operation_server  = module.production_operation_server
  development_operation_server = module.production_operation_server
}

output "production_network" {
  value = {
    vpc_id              = local.production_network.vpc_id
    aws_vpc_cidr        = var.aws_vpc_cidr_prd
    public_subnet_ids   = local.production_network.public_subnet_ids
    webapp_subnet_ids   = local.production_network.webapp_subnet_ids
    database_subnet_ids = local.production_network.database_subnet_ids
    availability_zones  = local.production_network.availability_zones
  }
}

output "development_network" {
  # dummy
  value = {
    vpc_id              = local.development_network.vpc_id
    aws_vpc_cidr        = var.aws_vpc_cidr_prd
    public_subnet_ids   = local.development_network.public_subnet_ids
    webapp_subnet_ids   = local.development_network.webapp_subnet_ids
    database_subnet_ids = local.development_network.database_subnet_ids
    availability_zones  = local.development_network.availability_zones
  }
}

output "disabled" {
  value = module.production_network.disabled
}

# ci/cd
output "ecr_csweb" {
  value = {
    app_repository_name   = module.ecr.csweb.app_repository_name
    app_arn               = module.ecr.csweb.app_arn
    app_repository_url    = module.ecr.csweb.app_repository_url
    nginx_repository_name = module.ecr.csweb.nginx_repository_name
    nginx_arn             = module.ecr.csweb.nginx_arn
    nginx_repository_url  = module.ecr.csweb.nginx_repository_url
  }
}

output "ecr_admweb" {
  value = {
    app_repository_name   = module.ecr.admweb.app_repository_name
    app_arn               = module.ecr.admweb.app_arn
    app_repository_url    = module.ecr.admweb.app_repository_url
    nginx_repository_name = module.ecr.admweb.nginx_repository_name
    nginx_arn             = module.ecr.admweb.nginx_arn
    nginx_repository_url  = module.ecr.admweb.nginx_repository_url
  }
}

output "ecr_migrate" {
  value = {
    app_repository_name = module.ecr.migrate.app_repository_name
    app_arn             = module.ecr.migrate.app_arn
    app_repository_url  = module.ecr.migrate.app_repository_url
  }
}

# operation server
output "production_operation_server" {
  value = {
    instance_id       = local.production_operation_server.id
    security_group_id = local.production_operation_server.security_group_id
    iam_role_id       = local.production_operation_server.iam_role_id
  }
}

output "development_operation_server" {
  # dummy
  value = {
    instance_id       = local.development_operation_server.id
    security_group_id = local.development_operation_server.security_group_id
    iam_role_id       = local.development_operation_server.iam_role_id
  }
}

output "operation_server_username" {
  value = var.operation_server_username
}

# cognito
output "cognito_local_development_user_pool_endpoint" {
  value = module.cognito_local_development.user_pool_endpoint
}
output "cognito_local_development_web_client_id" {
  value = module.cognito_local_development.web_client_id
}