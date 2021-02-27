locals {
  tags = {
    Env        = var.env
    Project    = var.project
    Management = "Terraform"
  }
}
resource "aws_cloudwatch_log_group" "ecs_service_csweb_app" {
  name = "/${var.project}/${var.env}/ecs/service/csweb/app"
  tags = merge({ Service = "csweb", Container = "app" }, local.tags)
}

resource "aws_cloudwatch_log_group" "ecs_service_csweb_nginx" {
  name = "/${var.project}/${var.env}/ecs/service/csweb/nginx"
  tags = merge({ Service = "csweb", Container = "nginx" }, local.tags)
}

resource "aws_cloudwatch_log_group" "ecs_service_admweb_app" {
  name = "/${var.project}/${var.env}/ecs/service/admweb/app"
  tags = merge({ Service = "admweb", Container = "app" }, local.tags)
}

resource "aws_cloudwatch_log_group" "ecs_service_admweb_nginx" {
  name = "/${var.project}/${var.env}/ecs/service/admweb/nginx"
  tags = merge({ Service = "admweb", Container = "nginx" }, local.tags)
}

resource "aws_cloudwatch_log_group" "ecs_batch_migrate_app" {
  name = "/${var.project}/${var.env}/ecs/batch/migrate/app"
  tags = merge({ App = "migrate", Container = "app" }, local.tags)
}
