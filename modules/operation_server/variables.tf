variable project {
  description = "project name. Example: foo-bar"
}

variable env {
  description = "dev/stg/prd"
}

variable iam_role_id {
  description = "IAM role of operation server iam to which policy will be attached" 
}

variable s3_provisioning_bucket_arn {
  description = "Arn of S3 bucket for provisioning asset"
}

variable "os_username" {
  description = "Username of operation server. Example: ubuntu"
}

variable "instance_id" {
  description = "Instance id of operation server."
}
