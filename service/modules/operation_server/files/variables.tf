data "aws_secretsmanager_secret" "root_password_secrets" {
  arn = local.root_password_secrets_arn
}

data "aws_secretsmanager_secret_version" "root_password_secrets" {
  secret_id = data.aws_secretsmanager_secret.root_password_secrets.id
}

locals {
  appdb_admin_role = "${local.appdb_name}_admin"
}