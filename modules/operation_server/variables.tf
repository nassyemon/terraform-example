variable network_env {
  description = "prd or dev."
}

variable vpc_id {
  description = "VPC id to place subnet into"
}

variable aws_vpc_cidr {
  description = "VPC cidr block. Example: 10.0.0.0/16"
}

variable public_subnet_id {
  description = "Public subnet id to create operation server instance."
}

variable operator_users {
  type = list
  description = "List of users (name) to whom instance connect policy will be attatched."
}