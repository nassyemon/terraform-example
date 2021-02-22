locals {
  operation_server_name = "${var.project}-${var.env}-operation-server"
}

data template_file operation_server {
  template = jsonencode(
{
    "Version": "2012-10-17",
    "Statement": [
    {
      "Action": [
        "s3:*",
    ],
      "Effect": "Allow",
      "Resource": [
        "$${provisioning_bucket_arn}",
        "$${provisioning_bucket_arn}/*"
      ]
    }
  ]
})

  vars = {
    provisioning_bucket_arn = var.s3_provisioning_bucket_arn
  }
}

resource aws_iam_policy operation_server {
  name = "${local.operation_server_name}-policy"
  description = " ${local.operation_server_name} policy to attach ${var.iam_role_id}"
  path = "/"

  policy = data.template_file.operation_server.rendered
}

resource aws_iam_role_policy_attachment operation_server {
  role       = var.iam_role_id
  policy_arn = aws_iam_policy.operation_server.arn
}
