locals {
  rds_ssm_path = "${var.ssm_base_path}/rds"
}

resource "aws_ssm_parameter" "username" {
  name        = "${local.rds_ssm_path}/username"
  type        = "String"
  value       = aws_db_instance.rds.username
  description = "username for ${local.rds_identifier}"

  depends_on = [aws_db_instance.rds]
}

resource "aws_secretsmanager_secret" "password" {
  name                    = "${local.rds_ssm_path}/password"
  description             = "password for ${local.rds_identifier}"
  recovery_window_in_days = 0
  depends_on              = [random_password.password]
}

resource "aws_secretsmanager_secret_version" "password" {
  secret_id     = aws_secretsmanager_secret.password.id
  secret_string = random_password.password.result

  depends_on = [random_password.password]
}
