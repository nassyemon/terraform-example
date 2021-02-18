locals {
  csweb_family = "${var.project}-${var.env}-csweb"
}

# ecs clusrter
resource aws_ecs_cluster csweb {
  name = "${local.csweb_family}-cluster"
}

# task definition for webapp
resource aws_ecs_task_definition csweb {
  family                = local.csweb_family
  container_definitions = local.csweb_task_definition
  task_role_arn         = aws_iam_role.ecs_task.arn
  execution_role_arn    = aws_iam_role.ecs_execution.arn
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                   = 512 # TODO
  memory                = 1024 # TODO
}
