output ecs_webapp {
  value = {
    arn = aws_cloudwatch_log_group.ecs_webapp.arn
    name = aws_cloudwatch_log_group.ecs_webapp.name
  }
}