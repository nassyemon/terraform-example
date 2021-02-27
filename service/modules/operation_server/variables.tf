variable "project" {
  description = "project name. Example: foo-bar"
}

variable "env" {
  description = "dev/stg/prd"
}

variable "ssm_base_path" {
  description = "SSM & Secrets manager base path."
}

variable "iam_role_id" {
  description = "IAM role of operation server iam to which policy will be attached"
}

variable "s3_bucket_provisioning" {
  type = map(any)
  description = "S3 bucket for provisioning asset"
}

variable "os_username" {
  description = "Username of operation server. Example: ubuntu"
}

variable "instance_id" {
  description = "Instance id of operation server."
}

variable "rds_identifier" {
  description = "Human friendly name for rds."
}

variable "rds_endpoint" {
  description = "Endpoint of RDS."
}

variable "rds_username" {
  description = "RDS root username."
}

variable "rds_password_secrets_arn" {
  description = "Secret manager arn of rds root password"
}

variable "rds_appdb_name" {
  description = "Name of the database that app will use."
}

variable "rds_appdb_username" {
  description = "Name of the user that app will use."
}
