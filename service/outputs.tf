output "rds_name" {
  value = module.rds.name
}

# for isntance-connect
output "operation_server_id" {
  value = local.operation_server.instance_id
}

output "operation_server_username" {
  value = local.operation_server_username
}