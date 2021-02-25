resource aws_ssm_parameter appdb_username {
  name        = local.appdb_username_ssm_path
  type        = "String"
  value       = local.appdb_username
  description = "Username for ${local.appdb_name} in ${local.rds_identifier}"

  depends_on = [mysql_grant.appdb_user]
}

resource aws_secretsmanager_secret appdb_user_password {
  name                    = local.appdb_user_password_secrets_path
  description             = "User password for  ${local.appdb_name} in ${local.rds_identifier}"
  recovery_window_in_days = 0
  depends_on              = [random_password.appdb_user_password]
}

resource aws_secretsmanager_secret_version appdb_user_password {
  secret_id     = aws_secretsmanager_secret.appdb_user_password.id
  secret_string = random_password.appdb_user_password.result

  depends_on = [mysql_grant.appdb_user, random_password.appdb_user_password]
}
