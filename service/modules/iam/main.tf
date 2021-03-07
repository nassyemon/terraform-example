data "aws_caller_identity" "current" {}

locals {
  region_account_id    = "${var.aws_region}:${data.aws_caller_identity.current.account_id}"
  log_group_arn_base   = "arn:aws:logs:${local.region_account_id}:log-group/${var.project}/${var.env}"
  ssm_resource_arn     = "arn:aws:ssm:${local.region_account_id}:parameter${var.ssm_base_path}/*"
  secrets_resource_arn = "arn:aws:secretsmanager:${local.region_account_id}:secret:${var.ssm_base_path}/*"

  tags = {
    Env        = var.env
    Project    = var.project
    Management = "Terraform"
  }
}