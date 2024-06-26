variable "project" {
  description = "project name. Example: foo-bar"
}

variable "env" {
  description = "dev/stg/prd"
}

variable "aws_region" {
  description = "Example: ap-northeast-1"
}

variable "ssm_base_path" {
  description = "SSM & Secrets manager base path."
}