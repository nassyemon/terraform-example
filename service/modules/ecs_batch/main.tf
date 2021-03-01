data "aws_caller_identity" "current" {}

locals {
  region_account_id = "${var.aws_region}:${data.aws_caller_identity.current.account_id}"
  family            = "${var.project}-${var.env}-${var.app_name}"
  cluster_name      = "${local.family}-cluster"
  task_definition   = jsonencode(yamldecode(data.template_file.task_definition_raw.rendered))

  tags = {
    Env        = var.env
    Project    = var.project
    Management = "Terraform"
  }
}

# template for task definition
data "template_file" "task_definition_raw" {
  template = file("${path.module}/task-definitions/${var.task_definition_yml}")

  vars = merge({
    environment       = var.env
    docker_repository = var.app_repository_url
    image_tag         = "latest_main" # TODO.
    # logs
    aws_region    = var.aws_region
    app_log_group = var.log_group_app_name
  }, var.task_template_parameters)
}

# ecs clusrter
resource "aws_ecs_cluster" "ecs_batch" {
  name = local.cluster_name
  setting {
    name = "containerInsights"
    value = "enabled"
  }
}

# task definition for webapp
resource "aws_ecs_task_definition" "ecs_batch" {
  family                   = local.family
  container_definitions    = local.task_definition
  task_role_arn            = var.iam_ecs_task_role_arn
  execution_role_arn       = var.iam_ecs_execution_role_arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory
}
