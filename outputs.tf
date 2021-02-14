output rds_name {
  value = module.rds.name
}

output rds_ssm_username_arn {
  value = module.rds.ssm_username_arn
}

output rds_secrets_password_arn {
  value = module.rds.secrets_password_arn
}