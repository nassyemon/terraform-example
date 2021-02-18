output "production_network" {
  value = {
    vpc_id              = module.production_network.vpc_id
    public_subnet_ids   = module.production_network.public_subnet_ids
    webapp_subnet_ids   = module.production_network.webapp_subnet_ids
    database_subnet_ids = module.production_network.database_subnet_ids
  }
}

# dummy
output "development_network" {
  value = {
    vpc_id              = module.production_network.vpc_id
    public_subnet_ids   = module.production_network.public_subnet_ids
    webapp_subnet_ids   = module.production_network.webapp_subnet_ids
    database_subnet_ids = module.production_network.database_subnet_ids
  }
}

output "disabled" {
  value = module.production_network.disabled
}

# ci/cd
output "ecr_csweb_app" {
  value = {
    arn            = module.ecr.webapp_arn
    repository_url = module.ecr.csweb_app_repository_url
  }
}
