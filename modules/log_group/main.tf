resource aws_cloudwatch_log_group ecs_webapp {
  name = "/${var.project}/${var.env}/ecs/webapp"

  tags = {
    Env = var.env
    Project = var.project
    Service = "ecs"
  }
}
