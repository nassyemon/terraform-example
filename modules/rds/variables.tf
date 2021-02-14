variable "project" {
  description = "project name. Example: foo-bar"
}

variable "env" {
  description = "dev/stg/prd"
}

variable "disabled" {
  description = "set 1 or true to reduce payment"
}

variable "name" {
  description = "Name for rds"
}

variable "database_subnet_ids" {
  type = list
  description = "List of ids of database subnet."
}

variable "rds_security_group_ids" {
  type = list
  description = "List of securty groups attached to RDS."
}

variable "username" {
  description = "username for rds"
}

variable "instance_class" {
  description = "Example: db.t2.micro"
}

variable "allocated_storage" {
  description = "Example: 20"
}

variable "storage_class" {
  description = "Example: gp2"
}

variable "multi_az" {
  description = "true/false"
}

variable "backup_window" {
  description = "Example: 05:20-05:50"
}

variable "maintenance_window" {
  description = "sun:04:00-sun:04:30"
}
