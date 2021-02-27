output "ecs_service_csweb" {
  value = {
    app_arn    = aws_cloudwatch_log_group.ecs_service_csweb_app.arn
    app_name   = aws_cloudwatch_log_group.ecs_service_csweb_app.name
    nginx_arn  = aws_cloudwatch_log_group.ecs_service_csweb_nginx.arn
    nginx_name = aws_cloudwatch_log_group.ecs_service_csweb_nginx.name
  }
}

output "ecs_service_admweb" {
  value = {
    app_arn    = aws_cloudwatch_log_group.ecs_service_admweb_app.arn
    app_name   = aws_cloudwatch_log_group.ecs_service_admweb_app.name
    nginx_arn  = aws_cloudwatch_log_group.ecs_service_admweb_nginx.arn
    nginx_name = aws_cloudwatch_log_group.ecs_service_admweb_nginx.name
  }
}

output "ecs_batch_migrate" {
  value = {
    app_arn  = aws_cloudwatch_log_group.ecs_batch_migrate_app.arn
    app_name = aws_cloudwatch_log_group.ecs_batch_migrate_app.name
  }
}