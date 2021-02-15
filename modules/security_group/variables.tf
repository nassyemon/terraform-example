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