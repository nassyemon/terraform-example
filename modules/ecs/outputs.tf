output ecs_task_role_arn {
  value = aws_iam_role.ecs_task.arn
}

output ecs_execiton_role_arn {
  value = aws_iam_role.ecs_execution.arn
}

# output ecs_task_family {
#   value = aws_ecs_task_definition.webapp.family
# }