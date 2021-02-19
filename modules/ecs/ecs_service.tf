
# webapp service
resource aws_ecs_service csweb {
  name = "${local.csweb_family}-service"
  cluster = aws_ecs_cluster.csweb.id
  task_definition = aws_ecs_task_definition.csweb.arn
  desired_count = 1 # TODO.
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent = 200
  # This may need to be adjusted if the container takes a while to start up
  # health_check_grace_period_seconds = 120
  launch_type = "FARGATE"

  network_configuration {
    subnets = var.webapp_subnet_ids
    security_groups = var.sg_ecs_csweb_ids
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.alb_target_group_csweb_arn
    container_name = "app"
    container_port = 80
  }
  # lifecycle {
  #   ignore_changes = [task_definition]
  # }
  depends_on = [var.alb_target_group_csweb_arn]
}
