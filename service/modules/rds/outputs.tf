output "name" {
  value = aws_db_instance.rds.name
}

output "address" {
  value = aws_db_instance.rds.address
}

output "port" {
  value = aws_db_instance.rds.port
}

output "identifier" {
  value = local.rds_identifier
}

output "endpoint" {
  value = aws_db_instance.rds.endpoint
}

output "subnet_group_id" {
  value = aws_db_subnet_group.rds.id
}

output "parameter_group_name" {
  value = aws_db_parameter_group.rds.name
}

output "username_ssm_arn" {
  value = aws_ssm_parameter.username.arn
}

output "password_secrets_arn" {
  value = aws_secretsmanager_secret.password.arn
}

output "username" {
  value = var.username
}