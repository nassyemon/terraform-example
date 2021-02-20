variable disabled {
  description = "set 1 or true to reduce payment"
}

variable aws_vpc_cidr {
  description = "VPC cidr block. Example: 10.0.0.0/16"
}

variable aws_vpc_tags_name {
  description = "VPC tag name."
}

variable network_env {
  description = "prd or dev."
}

variable destination_cidr_block {
  description = "Specify all traffic to be routed either trough Internet Gateway or NAT to access the internet"
}

variable availability_zones {
  type        = list
  description = "Example: ap-northeast-1a and ap-northeast-1c"
}

variable webapp_subnet_cidrs {
  type        = list
  description = "List of cidrs for webapp subnet. Length must eqauls to that of availability_zones."
}

variable database_subnet_cidrs {
  type        = list
  description = "List of cidrs for database subnet. Length must eqauls to that of availability_zones."
}

variable public_subnet_cidrs {
  type        = list
  description = "List of cidrs for public subnet. Length must eqauls to that of availability_zones."
}

variable use_single_nat_gateway {
  description = "Set true to create only one nat gateway, otherwise create nat gateway on each az."
}