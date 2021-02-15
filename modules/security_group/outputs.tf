output external_alb_id {
  value = aws_security_group.external_alb.id
}

output webapp_id {
  value = aws_security_group.webapp.id
}

output rds_id {
  value = aws_security_group.rds.id
}