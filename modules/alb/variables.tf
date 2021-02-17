variable project {
  description = "project name. Example: foo-bar"
}

variable env {
  description = "dev/stg/prd"
}

variable hosted_zone_id {
  description = "Hosted zone id found in Route53 hosted zone."
}

variable hosted_zone_name {
  description = "Example: example.com"
}

variable subdomain_external_alb {
  description = "Example: 'webapp_dev' in webapp_dev.example.com"
}

variable sg_external_alb_ids {
  type = list
  description = "List of securty groups attached to external alb"
}

variable vpc_id {
  description = "vpc_id to place alb target group."
}

variable public_subnet_ids {
  type = list
  description = "List of ids of database subnet."
}

variable webapp_health_check_path {
  description = "Example: /__healthcheck"
}

# variable external_alb_logs_bucket {
#   description = "Log bucket to store access logs of external alb."
# }