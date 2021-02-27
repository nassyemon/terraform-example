output "bucket_provisioning" {
  value = {
    arn = aws_s3_bucket.provisioning.arn
    id = aws_s3_bucket.provisioning.id
  }
}