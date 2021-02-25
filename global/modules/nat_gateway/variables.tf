variable "disabled" {
  description = "set 1 or true to reduce payment"
}

variable "network_env" {
  description = "prd or dev."
}

variable "subnet_ids" {
  type        = list(any)
  description = "List of subnets in which to place the NAT Gateway"
}

variable "subnet_count" {
  description = "Size of the subnet_ids. This needs to be provided because: value of 'count' cannot be computed"
}

variable "availability_zones" {
  type        = list(any)
  description = "Example: ap-northeast-1a and ap-northeast-1c"
}

variable "use_single_nat_gateway" {
  description = "Set true to create only one nat gateway, otherwise create nat gateway on each az."
}