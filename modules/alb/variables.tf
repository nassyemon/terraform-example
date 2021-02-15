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

