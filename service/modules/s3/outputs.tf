output "bucket_provisioning" {
  value = {
    arn = aws_s3_bucket.provisioning.arn
    id  = aws_s3_bucket.provisioning.id
  }
}
output "bucket_csweb_alb_access_log" {
  value = {
    arn = aws_s3_bucket.csweb_alb_access_log.arn
    id  = aws_s3_bucket.csweb_alb_access_log.id
  }
}

output "bucket_admweb_alb_access_log" {
  value = {
    arn = aws_s3_bucket.admweb_alb_access_log.arn
    id  = aws_s3_bucket.admweb_alb_access_log.id
  }
}