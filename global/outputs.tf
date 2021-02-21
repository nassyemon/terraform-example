output "production_network" {
  value = {
    vpc_id              = module.production_network.vpc_id
    aws_vpc_cidr        = var.aws_vpc_cidr_prd
    public_subnet_ids   = module.production_network.public_subnet_ids
    webapp_subnet_ids   = module.production_network.webapp_subnet_ids
    database_subnet_ids = module.production_network.database_subnet_ids
  }
}

output "development_network" {
  # dummy
  value = {
    vpc_id              = module.production_network.vpc_id
    aws_vpc_cidr        = var.aws_vpc_cidr_prd
    public_subnet_ids   = module.production_network.public_subnet_ids
    webapp_subnet_ids   = module.production_network.webapp_subnet_ids
    database_subnet_ids = module.production_network.database_subnet_ids
  }
}

output "disabled" {
  value = module.production_network.disabled
}

# operation server
output "production_operation_server" {
  value = {
    instance_id       = module.production_operation_server.id
    security_group_id = module.production_operation_server.security_group_id
  }
}

output "development_operation_server" {
  # dummy
  value = {
    instance_id       = module.production_operation_server.id
    security_group_id = module.production_operation_server.security_group_id
  }
}

# ci/cd
output "ecr_csweb_app" {
  value = {
    arn            = module.ecr.webapp_arn
    repository_url = module.ecr.csweb_app_repository_url
  }
}
