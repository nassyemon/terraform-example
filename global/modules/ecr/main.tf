resource aws_ecr_repository webapp {
  name                 = var.csweb_app_repository_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
