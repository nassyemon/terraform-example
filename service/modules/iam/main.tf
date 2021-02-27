data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  region_account_id  = "${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}"
  log_group_arn_base = "arn:aws:logs:${local.region_account_id}:log-group/${var.project}/${var.env}"
  ssm_parameter_path = "arn:aws:ssm:${local.region_account_id}:parameter/${var.project}/${var.env}/*"
}