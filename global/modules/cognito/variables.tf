variable "user_pool_name" {
  description = "name of cognito user-pool (Exmple: example-dev)"
}

variable "project" {
  description = "project name. Example: foo-bar"
}

variable "env" {
  description = "Exapmle: global, dev, stg..."
}

# variable "email_address" {
#   description = "Cognito's auto sending email address (Example: no-reply@example.com)"
# }

# variable "email_display_name" {
#   description = "Cognito's auto sending email display name (Example: no-reply)"
# }

# variable "email_idnetity_arn" {
#   description = "ARN of the SES verified email identity to to use."
# }