output webapp_task_role_arn {
  value = aws_iam_role.webapp_task.arn
}

output webapp_execiton_role_arn {
  value = aws_iam_role.ecs_execution.arn
}

# output webapp_task_family {
#   value = aws_ecs_task_definition.webapp.family
# }