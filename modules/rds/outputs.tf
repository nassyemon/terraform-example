output name {
  value = aws_db_instance.rds.name
}

output subnet_group_id {
  value = aws_db_subnet_group.rds.id
}

output parameter_group_name {
  value = aws_db_parameter_group.rds.name
}

output ssm_username_arn {
  value = aws_ssm_parameter.username.arn
}

output secrets_password_arn {
  value = aws_secretsmanager_secret.password.arn
}