variable "project" {
  description = "project name. Example: foo-bar"
}

variable "env" {
  description = "dev/stg/prd"
}

variable "vpc_id" {
  description = "vpc id"
}

variable "rds_port" {
  description = "rds port (3306 for mysql, 5432 for postgres)"
}

variable "webapp_subnet_ids" {
  description = "List of ids of public subnet."
}

# csweb
variable "csweb_alb_ingress_cidrs" {
  type        = list(string)
  description = "List of CIDRs from which csweb-alb allows request."
}

# admweb
variable "admweb_alb_ingress_cidrs" {
  type        = list(string)
  description = "List of CIDRs from which admweb-alb allows request."
}

# operation server.
variable "sg_operation_server_id" {
  description = "Security group id of operation server"
}
