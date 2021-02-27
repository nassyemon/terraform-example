variable "project" {
  description = "project name. Example: foo-bar"
}

variable "env" {
  description = "dev/stg/prd"
}

variable "app_name" {
  description = "Name of app. Example: migrate, route ..."
}

variable "iam_ecs_task_role_arn" {
  description = "Arn of iam role that is attached to ecs instance."
}

variable "iam_ecs_execution_role_arn" {
  description = "Arn of iam role that is used to execute ecs task."
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of ids of subnet where ecs task runs"
}

# ecs_service
variable "app_repository_url" {
  description = "Docker repository for app"
}

variable "sg_ecs_ids" {
  type        = list(string)
  description = "List of securty groups attached to ecs instances."
}

variable "log_group_app_name" {
  description = "Name of log group for app."
}

variable "task_definition_yml" {
  description = "Name of task definition yml file."
}

variable "task_template_parameters" {
  type        = map(any)
  description = "task defnition specific parameters."
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
