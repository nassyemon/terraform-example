output webapp_arn {
  value = aws_ecr_repository.webapp.arn
}

output csweb_app_repository_url {
  value = aws_ecr_repository.webapp.repository_url
}