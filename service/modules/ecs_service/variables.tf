variable "project" {
  description = "project name. Example: foo-bar"
}

variable "env" {
  description = "dev/stg/prd"
}

variable "aws_region" {
  description = "Example: ap-northeast-1"
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

variable "iam_ecs_autoscaling_role_arn" {
  description = "Arn of iam role that is used to autoscale ecs service."
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of ids of subnet where ecs task runs"
}

# task definition params
variable "task_definition_yml" {
  description = "Name of task definition yml file."
}

variable "app_repository_name" {
  description = "Repository name of app"
}

variable "app_repository_url" {
  description = "Docker repository for app"
}

variable "app_image_tag" {
  description = "DOcker image tag to pull. Example: latest_main"
}

variable "nginx_repository_name" {
  description = "Repository name for nginx"
}

variable "nginx_repository_url" {
  description = "Docker repository for nginx"
}

variable "nginx_image_tag" {
  description = "DOcker image tag to pull. Example: latest_main"
}

variable "sg_ecs_ids" {
  type        = list(string)
  description = "List of securty groups attached to ecs instances."
}

variable "log_group_app_name" {
  description = "Name of log group for app."
}

variable "log_group_nginx_name" {
  description = "Name of log group for nginx."
}

variable "task_template_parameters" {
  type        = map(any)
  description = "task defnition specific parameters."
}

# ecs service
variable "alb_target_group_arn" {
  description = "Arn of alb-target-group to which ecs instances are registered."
}


# task defintion parameters.
variable "task_cpu" {
  default     = 512
  description = "CPU unit (1024 for 1vCPU)"
}

variable "task_memory" {
  default     = 1024
  description = "Memory unit in GiB."
}

variable "service_desired_count" {
  default     = 1
  description = "Desired count of ecs task runing in service.."
}

variable "service_min_count" {
  default     = 1
  description = "Minimum count of ecs task to scale down."
}

variable "service_max_count" {
  default     = 2
  description = "Maximum count of ecs task to scale up."
}

variable "cpu_utilization_target" {
  default     = 50
  description = "Average CPU utilization target value. Autoscaling used it to scale up or in ecs tasks."
}

variable "cpu_utilization_scale_up_cooldown" {
  default     = 300
  description = "Cool-down time before another scale up occurs."
}

variable "cpu_utilization_scale_in_cooldown" {
  default     = 300
  description = "Cool-down time before another scale in occurs."
}
