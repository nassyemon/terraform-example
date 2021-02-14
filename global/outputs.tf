output "production_network_public_subnet_ids" {
  value = module.production_network.public_subnet_ids
}

output "production_network_webapp_subnet_ids" {
  value = module.production_network.webapp_subnet_ids
}

output "production_network_database_subnet_ids" {
  value = module.production_network.database_subnet_ids
}
