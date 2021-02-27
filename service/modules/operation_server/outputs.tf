output "appdb_username_ssm_arn" {
  value = "arn:aws:ssm:${local.region_account_id}:parameter${local.template_vars.appdb_username_ssm_path}"
}

output "appdb_user_password_secrets_arn" {
  value = "arn:aws:secretsmanager:${local.region_account_id}:secret:${local.template_vars.appdb_user_password_secrets_path}"
}