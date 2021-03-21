locals {
  provision_bucket_name             = "${var.project}-${var.env}-provisioning"
  csweb_alb_access_log_bucket_name  = "${var.project}-${var.env}-csweb-alb-access-log"
  admweb_alb_access_log_bucket_name = "${var.project}-${var.env}-admweb-alb-access-log"
  tags = {
    Project = var.project
    Env     = var.env
  }
  alb_access_log_bucket_poicy_template = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : {
      "Effect" : "Allow"
      "Action" : "s3:PutObject"
      "Resource" : "$${resource}"
      "Principal" : {
        "AWS" : "arn:aws:iam::$${elb_account_id}:root"
      }
    }
  })
}

data "aws_elb_service_account" "elb_account" {
  region = var.aws_region
}

# provisioning bucket
resource "aws_s3_bucket" "provisioning" {
  bucket = local.provision_bucket_name
  acl    = "private"
  tags   = merge({ Name = local.provision_bucket_name }, local.tags)

  versioning {
    enabled = true
  }

  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "provisioning" {
  bucket = aws_s3_bucket.provisioning.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_s3_bucket" "csweb_alb_access_log" {
  bucket = local.csweb_alb_access_log_bucket_name
  acl    = "private"
  tags   = merge({ Name = local.csweb_alb_access_log_bucket_name }, local.tags)
  lifecycle_rule {
    enabled = true
    expiration {
      days = "365"
    }
  }
}

data "template_file" "csweb_alb_access_log" {
  template = local.alb_access_log_bucket_poicy_template
  vars = {
    resource       = "${aws_s3_bucket.csweb_alb_access_log.arn}/*"
    elb_account_id = data.aws_elb_service_account.elb_account.id
  }
}

resource "aws_s3_bucket_policy" "csweb_alb_access_log" {
  bucket = aws_s3_bucket.csweb_alb_access_log.id
  policy = data.template_file.csweb_alb_access_log.rendered
}

resource "aws_s3_bucket" "admweb_alb_access_log" {
  bucket = local.admweb_alb_access_log_bucket_name
  acl    = "private"
  tags   = merge({ Name = local.admweb_alb_access_log_bucket_name }, local.tags)
  lifecycle_rule {
    enabled = true
    expiration {
      days = "365"
    }
  }
}

data "template_file" "admweb_alb_access_log" {
  template = local.alb_access_log_bucket_poicy_template
  vars = {
    resource       = "${aws_s3_bucket.admweb_alb_access_log.arn}/*"
    elb_account_id = data.aws_elb_service_account.elb_account.id
  }
}

resource "aws_s3_bucket_policy" "admweb_alb_access_log" {
  bucket = aws_s3_bucket.admweb_alb_access_log.id
  policy = data.template_file.admweb_alb_access_log.rendered
}