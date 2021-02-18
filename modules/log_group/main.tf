resource aws_cloudwatch_log_group ecs_csweb_app {
  name = "/${var.project}/${var.env}/ecs/csweb_app"

  tags = {
    Env = var.env
    Project = var.project
    Service = "ecs"
  }
}
