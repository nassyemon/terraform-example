locals {
  endpoint                            = "${endpoint}"
  rds_identifier                      = "${rds_identifier}"
  root_username                       = "${root_username}"
  root_password_secrets_arn           = "${root_password_secrets_arn}"
  appdb_name                          = "${appdb_name}"
  appdb_username                      = "${appdb_username}"
  appdb_username_ssm_path             = "${appdb_username_ssm_path}"
  appdb_user_password_secrets_path    = "${appdb_user_password_secrets_path}"
}
