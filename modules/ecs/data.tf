data aws_caller_identity current {}

data aws_region current {}

locals {
  ecs_log_group = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group/${var.project}/${var.env}/ecs/*"
  ssm_parameter_path = "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/${var.project}/${var.env}/*"
}
