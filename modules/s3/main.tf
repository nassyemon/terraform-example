locals {
  provision_bucket_name = "${var.project}-${var.env}-provisioning"
  tags = {
    Project = var.project
    Env = var.env
  }
}

resource aws_s3_bucket provisioning {
  bucket = local.provision_bucket_name
  acl    = "private"
  tags = merge({ Name = local.provision_bucket_name }, local.tags)

  versioning {
    enabled = true
  }

  force_destroy = true
}

resource aws_s3_bucket_public_access_block provisioning {
  bucket = aws_s3_bucket.provisioning.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}
