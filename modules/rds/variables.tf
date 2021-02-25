variable "project" {
  description = "project name. Example: foo-bar"
}

variable "env" {
  description = "dev/stg/prd"
}

variable "ssm_base_path" {
  description = "SSM & Secrets manager base path."
}

variable "disabled" {
  description = "set 1 or true to reduce payment"
}

variable "name" {
  description = "Name for rds"
}

variable "database_subnet_ids" {
  type        = list(any)
  description = "List of ids of database subnet."
}

variable "rds_security_group_ids" {
  type        = list(any)
  description = "List of securty groups attached to RDS."
}

variable "port" {
  description = "port that the rds listens"
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
