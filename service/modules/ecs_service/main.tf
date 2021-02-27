data "aws_region" "current" {}

locals {
  family          = "${var.project}-${var.env}-${var.service_name}"
  task_definition = jsonencode(yamldecode(data.template_file.task_definition_raw.rendered))
}

# template for task definition
data "template_file" "task_definition_raw" {
  template = file("${path.module}/task-definitions/${var.task_definition_yml}")

  vars = merge({
    environment          = var.env
    docker_repository    = var.app_repository_url
    image_tag            = "latest_main" # TODO.
    nginx_container_port = 80
    # logs
    aws_region      = data.aws_region.current.name
    app_log_group   = var.log_group_app_name
    nginx_log_group = var.log_group_nginx_name
  }, var.task_template_parameters)
}

# ecs clusrter
resource "aws_ecs_cluster" "ecs_service" {
  name = "${local.family}-cluster"
}

# task definition for webapp
resource "aws_ecs_task_definition" "ecs_service" {
  family                   = local.family
  container_definitions    = local.task_definition
  task_role_arn            = var.iam_ecs_task_role_arn
  execution_role_arn       = var.iam_ecs_execution_role_arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory
}


# webapp service
resource "aws_ecs_service" "ecs_service" {
  name                               = "${local.family}-service"
  cluster                            = aws_ecs_cluster.ecs_service.id
  task_definition                    = aws_ecs_task_definition.ecs_service.arn
  desired_count                      = var.service_desired_count
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  # This may need to be adjusted if the container takes a while to start up
  # health_check_grace_period_seconds = 120
  launch_type = "FARGATE"

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = var.sg_ecs_ids
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = "app"
    container_port   = 80
  }
  # lifecycle {
  #   ignore_changes = [task_definition]
  # }
  depends_on = [var.alb_target_group_arn]
}
