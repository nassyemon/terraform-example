variable "aws_region" {
  description = "Example: ap-northeast-1"
}
variable "disabled" {
  default     = false
  description = "set true or 1 to reduce payment"
}
variable "aws_vpc_cidr_prd" {
  description = "VPC cidr block. Example: 10.0.0.0/16"
}
variable "availability_zones" {
  type        = list
  description = "Example: ap-northeast-1a and ap-northeast-1c"
}
variable "webapp_subnet_cidrs_prd" {
  type        = list
  description = "List of cidrs for webapp subnet (production). Length must eqauls to that of availability_zones."
}
variable "database_subnet_cidrs_prd" {
  type        = list
  description = "List of cidrs for database subnet (production). Length must eqauls to that of availability_zones."
}
variable "public_subnet_cidrs_prd" {
  type        = list
  description = "List of cidrs for public subnet (production). Length must eqauls to that of availability_zones."
}
variable "aws_vpc_tags_name" {
  description = "VPC tag name."
}
variable "destination_cidr_block" {
  default     = "0.0.0.0/0"
  description = "Specify all traffic to be routed either trough Internet Gateway or NAT to access the internet"
}