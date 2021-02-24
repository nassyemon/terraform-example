output "rds_name" {
  value = module.rds.name
}

output "rds_ssm_username_arn" {
  value = module.rds.ssm_username_arn
}

output "rds_secrets_password_arn" {
  value = module.rds.secrets_password_arn
}

# for isntance-connect
output "operation_server_id" {
  value = local.operation_server.instance_id
}

output "operation_server_username" {
  value = local.operation_server_username
}