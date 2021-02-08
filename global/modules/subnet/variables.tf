variable "name" {
  description = "Name of the subnet, actual name will be, for example: name-ap-northeast-1a"
}

variable "network_env" {
  description = "prd or dev."
}

variable "cidrs" {
  type        = list
  description = "List of cidrs. Length must eqauls to that of availability_zones."
}

variable "availability_zones" {
  type        = list
  description = "Example: ap-northeast-1a and ap-northeast-1c"
}

variable "vpc_id" {
  description = "VPC id to place subnet into"
}
