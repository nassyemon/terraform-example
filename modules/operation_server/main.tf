data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

locals {
  region_account_id = "${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}"
  operation_server_name = "${var.project}-${var.env}-operation-server"
}

data "template_file" "operation_server" {
  template = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : [
            "s3:*",
          ],
          "Effect" : "Allow",
          "Resource" : [
            "$${provisioning_bucket_arn}",
            "$${provisioning_bucket_arn}/*"
          ]
        },
        {
          "Action" : ["ssm:DescribeParameters"],
          "Effect" : "Allow",
          "Resource" : "*"
        },
        {
          "Action" : ["ssm:*"],
          "Effect" : "Allow",
          "Resource" : "$${ssm_resource_arn}"
        },
        {
          "Action" : ["secretsmanager:*"],
          "Effect" : "Allow",
          "Resource" : "$${secrets_resource_arn}"
        }
      ]
  })

  vars = {
    provisioning_bucket_arn = var.s3_provisioning_bucket_arn
    ssm_resource_arn =  "arn:aws:ssm:${local.region_account_id}:parameter${var.ssm_base_path}/*"
    secrets_resource_arn = "arn:aws:secretsmanager:${local.region_account_id}:secret:${var.ssm_base_path}/*"
  }
}

resource "aws_iam_policy" "operation_server" {
  name        = "${local.operation_server_name}-policy"
  description = " ${local.operation_server_name} policy to attach ${var.iam_role_id}"
  path        = "/"

  policy = data.template_file.operation_server.rendered
}

resource "aws_iam_role_policy_attachment" "operation_server" {
  role       = var.iam_role_id
  policy_arn = aws_iam_policy.operation_server.arn
}
