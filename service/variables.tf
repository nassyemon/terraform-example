variable "project" {
  default = "terraform"
}

variable "disabled" {
  default     = false
  description = "set true or 1 to reduce payment"
}

variable "env" {
  description = "dev/stg/prd"
}

variable "network_env" {
  description = "Example: production_network"
}

variable "aws_region" {
  description = "Example: ap-northeast-1"
}

variable "global_be_bucket" {
}

variable "global_be_key" {
}

variable "global_be_region" {
}

# rds
variable "rds_name" {
  description = "Name for rds"
}

variable "rds_username" {
  description = "Username for rds"
}

variable "rds_instance_params" {
  type        = map(any)
  description = "instance_class, storage_class, allocated_storage ..."
}

variable "rds_appdb_name" {
  description = "Name of the database that app will use."
}

variable "rds_appdb_username" {
  description = "Name of the user that app will use."
}

# alb common
variable "hosted_zone_id" {
  description = "Hosted zone id found in Route53 hosted zone."
}

variable "hosted_zone_name" {
  description = "Example: example.com"
}

# csweb
variable "csweb_subdomain" {
  description = "Example: 'dev-csweb' in dev-csweb.example.com"
}

variable "csweb_alb_ingress_cidrs" {
  type        = list(string)
  description = "List of CIDRs from which csweb-alb allows request."
}

variable "csweb_health_check_path" {
  description = "Example: /__healthcheck"
}

variable "csweb_ecs_params" {
  type        = map(any)
  description = "task_cpu, task_memory, service_desired_count, ..."
}

# admin web
variable "admweb_subdomain" {
  description = "Example: 'dev-admweb' in dev-csweb.example.com"
}

variable "admweb_alb_ingress_cidrs" {
  type        = list(string)
  description = "List of CIDRs from which admweb-alb allows request."
}

variable "admweb_health_check_path" {
  description = "Example: /__healthcheck"
}

variable "admweb_ecs_params" {
  type        = map(any)
  description = "task_cpu, task_memory, service_desired_count, ..."
}

variable "batch_general_ecs_params" {
  type        = map(any)
  description = "task_cpu, task_memory, ..."
}