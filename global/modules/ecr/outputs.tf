output "csweb" {
  value = {
    app_arn              = aws_ecr_repository.csweb_app.arn
    app_repository_url   = aws_ecr_repository.csweb_app.repository_url
    nginx_arn            = aws_ecr_repository.csweb_nginx.arn
    nginx_repository_url = aws_ecr_repository.csweb_nginx.repository_url
  }
}

output "admweb" {
  value = {
    app_arn              = aws_ecr_repository.admweb_app.arn
    app_repository_url   = aws_ecr_repository.admweb_app.repository_url
    nginx_arn            = aws_ecr_repository.admweb_nginx.arn
    nginx_repository_url = aws_ecr_repository.admweb_nginx.repository_url
  }
}

output "migrate" {
  value = {
    app_arn            = aws_ecr_repository.migrate_app.arn
    app_repository_url = aws_ecr_repository.migrate_app.repository_url
  }
}