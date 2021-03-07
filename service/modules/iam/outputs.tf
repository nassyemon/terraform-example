output "ecs_task_role_arn" {
  value = aws_iam_role.ecs_task.arn
}

output "ecs_execiton_role_arn" {
  value = aws_iam_role.ecs_execution.arn
}

output "ecs_autoscaling_role_arn" {
  value = aws_iam_role.ecs_autoscaling.arn
}