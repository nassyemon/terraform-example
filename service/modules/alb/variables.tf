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

variable "subdomain_csweb" {
  description = "Example: 'dev-webapp' in dev-webapp.example.com"
}

variable "sg_alb_csweb_ids" {
  type        = list(any)
  description = "List of securty groups attached to csweb alb"
}

variable "vpc_id" {
  description = "vpc_id to place alb target group."
}

variable "public_subnet_ids" {
  type        = list(any)
  description = "List of ids of database subnet."
}

variable "csweb_app_health_check_path" {
  description = "Example: /__healthcheck"
}

# variable csweb_logs_bucket {
#   description = "Log bucket to store access logs of csweb alb."
# }