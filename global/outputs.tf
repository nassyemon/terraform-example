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
  }
}

output "disabled" {
  value = module.production_network.disabled
}

# operation server
output "production_operation_server" {
  value = {
    instance_id              = local.production_operation_server.id
    security_group_id        = local.production_operation_server.security_group_id
    iam_role_id              = local.production_operation_server.iam_role_id
    last_provision_timestamp = local.production_operation_server.last_provision_timestamp
  }
}

output "development_operation_server" {
  # dummy
  value = {
    instance_id              = local.development_operation_server.id
    security_group_id        = local.development_operation_server.security_group_id
    iam_role_id              = local.development_operation_server.iam_role_id
    last_provision_timestamp = local.development_operation_server.last_provision_timestamp
  }
}

# ci/cd
output "ecr_csweb_app" {
  value = {
    arn            = module.ecr.webapp_arn
    repository_url = module.ecr.csweb_app_repository_url
  }
}

output "operation_server_username" {
  value = var.operation_server_username
}
