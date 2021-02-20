variable project {
  description = "project name. Example: foo-bar"
}

variable env {
  description = "dev/stg/prd"
}

variable public_subnet_id {
  description = "Public subnet id to create operation server instance."
}

variable sg_operation_server_ids {
  type = list
  description = "List of securty groups attached to operation server instance."
}

variable operator_users {
  type = list
  description = "List of users (name) to whom instance connect policy will be attatched."
}