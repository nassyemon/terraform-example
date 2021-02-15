variable project {
  default = "terraform"
}

variable disabled {
  default     = false
  description = "set true or 1 to reduce payment"
}

variable env {
  description = "dev/stg/prd"
}

variable network_env {
  description = "Example: production_network"
}

variable aws_region {
  description = "Example: ap-northeast-1"
}

variable global_be_bucket {
}

variable global_be_key {
}

variable global_be_region {
}

# rds
variable rds_name {
  description = "Name for rds"
}

variable rds_username {
  description = "Username for rds"
}

variable rds_instance_params {
  type        = map(any)
  description = "instance_class, storage_class, allocated_storage ..."
}