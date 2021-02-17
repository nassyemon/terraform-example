data aws_caller_identity current {}

data aws_region current {}

locals {
  ecs_log_group = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group/${var.project}/${var.env}/ecs/*"
  ssm_parameter_path = "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/${var.project}/${var.env}/*"
  webapp_task_definition = jsonencode(yamldecode(data.template_file.webapp_task_definition_raw.rendered))
}

# template for task definition
data template_file webapp_task_definition_raw {
  template = file("${path.module}/task-definitions/webapp.yaml")

  vars = {
    environment       = var.env
    docker_repository = var.webapp_repository_url
    app_container_port = 80 # TODO
    aws_region        = data.aws_region.current.name
    aws_log_group     = var.log_group_ecs_webapp.name
    app_log_prefix    = "webapp-"
  }
}
