locals {
  webapp_family = "${var.project}-${var.env}-webapp"
}

# template for task definition
data template_file webapp_task_definition_raw {
  template = file("${path.module}/task-definitions/webapp.yaml")

  vars = {
    environment       = var.env
    docker_repository = var.webapp_repository_url
    app_container_port = 80 # TODO
    aws_region        = data.aws_region.current.name
    aws_log_group     = local.ecs_log_group
    app_log_prefix    = "webapp-"
  }
}

locals {
  webapp_task_definition = jsonencode(yamldecode(data.template_file.webapp_task_definition_raw.rendered))
}

# task definition for webapp
resource aws_ecs_task_definition webapp {
  family                = local.webapp_family
  container_definitions = local.webapp_task_definition
  task_role_arn         = aws_iam_role.webapp_task.arn
  execution_role_arn    = aws_iam_role.ecs_execution.arn
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                   = 512 # TODO
  memory                = 1024 # TODO
}
