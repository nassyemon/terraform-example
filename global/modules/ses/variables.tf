variable "aws_region" {
  description = "Example: ap-northeast-1"
}

variable "hosted_zone_name" {
  description = "Example: example.com"
}

variable "hosted_zone_id" {
  description = "Hosted zone id found in Route53 hosted zone."
}

variable "developer_email_addresses" {
  type        = list(any)
  description = "email addresses to which SES can send mail (in sandbox mode.)"
}