output "alb_csweb_id" {
  value = aws_security_group.alb_csweb.id
}

output "ecs_csweb_id" {
  value = aws_security_group.ecs_csweb.id
}

output "alb_admweb_id" {
  value = aws_security_group.alb_admweb.id
}

output "ecs_admweb_id" {
  value = aws_security_group.ecs_admweb.id
}

output "ecs_batch_general_id" {
  value = aws_security_group.ecs_batch_general.id
}

output "rds_id" {
  value = aws_security_group.rds.id
}
