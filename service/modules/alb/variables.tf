variable "project" {
  description = "project name. Example: foo-bar"
}

variable "env" {
  description = "dev/stg/prd"
}

variable "hosted_zone_id" {
  description = "Hosted zone id found in Route53 hosted zone."
}

variable "hosted_zone_name" {
  description = "Example: example.com"
}

variable "subdomain" {
  description = "Example: 'dev-webapp' in dev-webapp.example.com"
}

variable "sg_alb_ids" {
  type        = list(any)
  description = "List of securty groups attached to alb"
}

variable "vpc_id" {
  description = "vpc_id to place alb target group."
}

variable "subnet_ids" {
  type        = list(any)
  description = "List of ids of database subnet."
}

variable "health_check_path" {
  description = "Example: /__healthcheck"
}

variable "listen_http" {
  description = "True to create http (80) listner."
}
variable "redirect_https" {
  description = "True to redirect access from http request to https."
}

variable "internal" {
  description = "True to create internal (not internet-facing) alb."
}

variable "s3_bucket_access_log" {
  description = "Log bucket to store access logs of alb."
}