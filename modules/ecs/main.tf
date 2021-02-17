locals {
  webapp_family = "${var.project}-${var.env}-webapp"
}

# ecs clusrter
resource "aws_ecs_cluster" "webapp" {
  name = "${local.webapp_family}-cluster"
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
