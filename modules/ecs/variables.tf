variable project {
  description = "project name. Example: foo-bar"
}

variable env {
  description = "dev/stg/prd"
}

variable webapp_subnet_ids {
  description = "List of ids of webapp subnet."
}

variable sg_ecs_csweb_ids {
  type = list
  description = "List of securty groups attached to ecs instances."
}

variable csweb_app_repository_url {
  description = "Docker repository for csweb app"
}

variable alb_target_group_csweb_arn {
  description = "Arn of target-group for csweb-alb"
}

variable log_group_ecs_csweb_app {
  description = "log group for csweb app."
}
