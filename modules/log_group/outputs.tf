output "ecs_csweb_app" {
  value = {
    arn  = aws_cloudwatch_log_group.ecs_csweb_app.arn
    name = aws_cloudwatch_log_group.ecs_csweb_app.name
  }
}