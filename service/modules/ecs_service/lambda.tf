locals {
  lambda_name_prefix = "${local.family}-ecs"
  const_filename     = "const.py"
  files_dir          = "${path.module}/files"

  # names should be unique.
  functions = [
    {
      name    = "${local.lambda_name_prefix}-update-task-defintion"
      handler = "update_task_definition.handler"
    },
    {
      name    = "${local.lambda_name_prefix}-update-service"
      handler = "update_service.handler"
    }
  ]
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
            "ecs:RegisterTaskDefinition",
            "ecs:DeregisterTaskDefinition",
          ],
          "Effect" : "Allow",
          "Resource" : "*"
        },
        {
          "Action" : [
            "ecr:DescribeImages",
          ],
          "Effect" : "Allow",
          "Resource" : "*"
        },
        {
          "Action" : [
            "ecs:UpdateService",
          ],
          "Effect" : "Allow",
          "Resource" : "*",
          "Condition" : {
            "ArnEquals" : {
              "ecs:cluster" : "$${service_cluster_arn}"
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
    service_cluster_arn        = aws_ecs_cluster.ecs_service.arn
    log_group_resource         = "arn:aws:logs:${local.region_account_id}:log-group:/aws/lambda/${local.lambda_name_prefix}*"
  }
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "${local.lambda_name_prefix}-lambda-policy"
  description = "Lambda policy for ${local.family} ecs operations"
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

  tags = merge({
    Policy = aws_iam_policy.lambda_policy.name
  }, local.tags)
}

resource "aws_iam_role_policy_attachment" "lambda_role_attach" {
  role       = aws_iam_role.lambda_role.id
  policy_arn = aws_iam_policy.lambda_policy.arn
}

data "archive_file" "lambda_package" {
  type = "zip"
  source {
    content = templatefile("${path.module}/templates/${local.const_filename}", {
      lambda_name            = jsonencode(local.functions[count.index].name)
      task_definition_family = jsonencode(aws_ecs_task_definition.ecs_service.family)
      app_repository_name    = jsonencode(var.app_repository_name)
      app_image_tag          = jsonencode(var.app_image_tag)
      app_repository_url     = jsonencode(var.app_repository_url)
      nginx_repository_name  = jsonencode(var.nginx_repository_name)
      nginx_image_tag        = jsonencode(var.nginx_image_tag)
      nginx_repository_url   = jsonencode(var.nginx_repository_url)
      service_name           = jsonencode(aws_ecs_service.ecs_service.name)
      service_cluster_arn    = jsonencode(aws_ecs_cluster.ecs_service.arn)
    })
    filename = local.const_filename
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
  role             = aws_iam_role.lambda_role.arn
  filename         = data.archive_file.lambda_package[count.index].output_path
  function_name    = local.functions[count.index].name
  handler          = local.functions[count.index].handler
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
