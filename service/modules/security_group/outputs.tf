output "alb_csweb_id" {
  value = aws_security_group.alb_csweb.id
}

output "ecs_csweb_id" {
  value = aws_security_group.ecs_csweb.id
}

output "rds_id" {
  value = aws_security_group.rds.id
}
