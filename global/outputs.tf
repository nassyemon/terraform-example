output "production_network" {
    value = {
      public_subnet_ids = module.production_network.public_subnet_ids
      webapp_subnet_ids = module.production_network.webapp_subnet_ids
      database_subnet_ids = module.production_network.database_subnet_ids
    }
}

# dummy.
output "development_network" {
    value = {
      public_subnet_ids = module.production_network.public_subnet_ids
      webapp_subnet_ids = module.production_network.webapp_subnet_ids
      database_subnet_ids = module.production_network.database_subnet_ids
    }
}

output "disabled" {
  value = module.production_network.disabled
}