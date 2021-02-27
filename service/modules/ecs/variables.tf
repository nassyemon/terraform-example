variable "project" {
  description = "project name. Example: foo-bar"
}

variable "env" {
  description = "dev/stg/prd"
}

variable "webapp_subnet_ids" {
  description = "List of ids of webapp subnet."
}

# csweb
variable "csweb_app_repository_url" {
  description = "Docker repository for csweb app"
}

variable "csweb_nginx_repository_url" {
  description = "Docker repository for csweb nginx"
}

variable "sg_ecs_csweb_ids" {
  type        = list(any)
  description = "List of securty groups attached to csweb-app ecs instances."
}

variable "alb_target_group_csweb_arn" {
  description = "Arn of target-group for csweb-alb"
}

variable "log_group_ecs_csweb_app" {
  description = "log group for csweb app."
}

# # admin web
# variable "admweb_app_repository_url" {
#   description = "Docker repository for admin web app"
# }

# variable "admweb_nginx_repository_url" {
#   description = "Docker repository for admin web nginx"
# }


# # migrate

# variable "migrate_app_repository_url" {
#   description = "Docker repository for migration app"
# }

# variable "sg_ecs_migrate_app_ids" {
#   type        = list(any)
#   description = "List of securty groups attached to migrate-app ecs instances."
# }

# variable "log_group_ecs_migrate_app" {
#   description = "log group for migration app."
# }
