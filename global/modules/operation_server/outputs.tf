output "id" {
  value = aws_instance.operation_server.id
}

output "security_group_id" {
  value = aws_security_group.operation_server.id
}

output "iam_role_id" {
  value = aws_iam_role.operation_server.id
}
