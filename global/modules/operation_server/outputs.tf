output id {
  value = aws_instance.operation_server.id
}

output security_group_id {
  value = aws_security_group.operation_server.id
}

output instance_profile_id {
  value = aws_iam_instance_profile.operation_server.id
}