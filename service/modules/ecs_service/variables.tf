variable "project" {
  description = "project name. Example: foo-bar"
}

variable "env" {
  description = "dev/stg/prd"
}

variable "service_name" {
  description = "Name of service. Example: csweb, admweb ..."
}

variable "iam_ecs_task_role_arn" {
  description = "Arn of iam role that is attached to ecs instance."
}

variable "iam_ecs_execution_role_arn" {
  description = "Arn of iam role that is used to execute ecs task."
}

variable "webapp_subnet_ids" {
  type        = list(string)
  description = "List of ids of webapp subnet."
}

# ecs_service
variable "app_repository_url" {
  description = "Docker repository for app"
}

variable "nginx_repository_url" {
  description = "Docker repository for nginx"
}

variable "sg_ecs_ids" {
  type        = list(string)
  description = "List of securty groups attached to ecs instances."
}

variable "alb_target_group_arn" {
  description = "Arn of alb-target-group to which ecs instances are registered."
}

variable "log_group_app_name" {
  description = "Name of log group for app."
}

variable "log_group_nginx_name" {
  description = "Name of log group for nginx."
}

variable "task_definition_yml" {
  description = "Name of task definition yml file."
}

# task defintion parameters.
variable "task_cpu" {
  default = 512
  description = "CPU unit (1024 for 1vCPU)"
}

variable "task_memory" {
  default = 1024
  description = "Memory unit in GiB."
}

variable "service_desired_count" {
  default = 1
  description = "Desired count of ecs task runing in service.."
}