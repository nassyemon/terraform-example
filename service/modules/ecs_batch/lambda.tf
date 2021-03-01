locals {
  lambda_name_prefix = "${local.family}-lambda-invoker"
  data_filename      = "data.py"
  files_dir          = "${path.module}/files"

  functions = [for key, command in var.command_map : (
    { name = "${local.lambda_name_prefix}-${key}", command = command }
  )]
}

# iam policy
data "template_file" "lambda_policy" {
  template = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : [
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          "Effect" : "Allow",
          "Resource" : "$${log_group_resource}",
        },
        {
          "Action" : [
            "ecs:DescribeTaskDefinition",
          ],
          "Effect" : "Allow",
          "Resource" : "*"
        },
        {
          "Action" : [
            "ecs:RunTask",
          ],
          "Effect" : "Allow",
          "Resource" : "*",
          "Condition" : {
            "ArnEquals" : {
              "ecs:cluster" : "$${batch_cluster_arn}"
            }
          }
        },
        {
          "Action" : [
            "iam:PassRole"
          ],
          "Effect" : "Allow",
          "Resource" : [
            "$${iam_ecs_execution_role_arn}",
            "$${iam_ecs_task_role_arn}"
          ]
        },
      ]
  })

  vars = {
    iam_ecs_task_role_arn      = var.iam_ecs_task_role_arn
    iam_ecs_execution_role_arn = var.iam_ecs_execution_role_arn
    batch_cluster_arn          = aws_ecs_cluster.ecs_batch.arn
    log_group_resource         = "arn:aws:logs:${local.region_account_id}:log-group:/aws/lambda/${local.lambda_name_prefix}*"
  }
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "${local.family}-lambda-invoker-policy"
  description = "lambda invoker policy for ${local.family}"
  path        = "/"

  policy = data.template_file.lambda_policy.rendered
}

resource "aws_iam_role" "lambda_role" {
  name = "${local.family}-lambda-invoker-role"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : "sts:AssumeRole",
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "lambda.amazonaws.com"
          },
        }
      ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_role_attach" {
  role       = aws_iam_role.lambda_role.id
  policy_arn = aws_iam_policy.lambda_policy.arn
}

data "archive_file" "lambda_package" {
  type = "zip"
  source {
    content = templatefile("${path.module}/templates/${local.data_filename}", {
      lambda_name            = jsonencode(local.functions[count.index].name)
      app_container_name     = jsonencode("app")
      command                = jsonencode(local.functions[count.index].command)
      task_definition_family = jsonencode(aws_ecs_task_definition.ecs_batch.family)
      batch_cluster_name     = jsonencode(local.cluster_name)
      batch_cluster_arn      = jsonencode(aws_ecs_cluster.ecs_batch.arn)
      security_group_ids     = jsonencode(var.sg_ecs_ids)
      subnet_ids             = jsonencode(var.subnet_ids)
    })
    filename = local.data_filename
  }
  dynamic "source" {
    for_each = fileset(local.files_dir, "**")
    iterator = each
    content {
      content  = file("${local.files_dir}/${each.value}")
      filename = each.value
    }
  }
  output_path = "${path.module}/.temp/${local.functions[count.index].name}.zip"

  count = length(local.functions)
}


resource "aws_lambda_function" "lambda" {
  filename         = data.archive_file.lambda_package[count.index].output_path
  function_name    = local.functions[count.index].name
  role             = aws_iam_role.lambda_role.arn
  handler          = "main.lambda_handler"
  source_code_hash = data.archive_file.lambda_package[count.index].output_base64sha256
  runtime          = "python3.8"

  tags = merge({ Function = local.functions[count.index].name }, local.tags)
  environment {
    variables = {
      env     = var.env
      project = var.project
    }
  }

  memory_size = 128
  timeout     = 300

  count      = length(local.functions)
  depends_on = [aws_cloudwatch_log_group.lambda_logs]
}
resource "aws_cloudwatch_log_group" "lambda_logs" {
  name  = "/aws/lambda/${local.functions[count.index].name}"
  tags  = merge({ Function = local.functions[count.index].name }, local.tags)
  count = length(local.functions)
}
