variable project {
  description = "project name. Example: foo-bar"
}

variable env {
  description = "dev/stg/prd"
}

variable webapp_subnet_ids {
  description = "List of ids of webapp subnet."
}

variable sg_webapp_ids {
  type = list
  description = "List of securty groups attached to ecs instances."
}

variable webapp_repository_url {
  description = "Docker repository for webappp"
}

variable alb_target_group_external_alb_arn {
  description = "Arn of target-group for external-alb"
}

variable log_group_ecs_webapp {
  description = "log group for webapp."
}
