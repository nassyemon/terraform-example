variable "network_env" {
  description = "prd or dev."
}

variable "subnet_ids" {
  type        = list
  description = "List of subnets in which to place the NAT Gateway"
}

variable "subnet_count" {
  description = "Size of the subnet_ids. This needs to be provided because: value of 'count' cannot be computed"
}

variable "availability_zones" {
  type        = list
  description = "Example: ap-northeast-1a and ap-northeast-1c"
}
