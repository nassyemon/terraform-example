
locals {
  ecs_log_group   = "${local.log_group_arn_base}/ecs/*"
  ecs_name_prefix = "${var.project}-${var.env}-ecs"
}

locals {
  assume_role_policy_ecs_tasks = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : ["ecs-tasks.amazonaws.com"]
          },
          "Action" : "sts:AssumeRole"
        }
      ]
  })
}

data "template_file" "ecs_task_policy" {
  template = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          "Effect" : "Allow",
          "Resource" : "$${ecs_log_group}"
        }
      ]
  })

  vars = {
    ecs_log_group = local.ecs_log_group
  }
}

data "template_file" "ecs_execution_policy" {
  template = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : ["ssm:DescribeParameters"],
          "Effect" : "Allow",
          "Resource" : "*"
        },
        {
          "Action" : ["ssm:GetParameters"],
          "Effect" : "Allow",
          "Resource" : "$${ssm_resource_arn}"
        },
        {
          "Action" : ["secretsmanager:GetSecretValue"],
          "Effect" : "Allow",
          "Resource" : "$${secrets_resource_arn}"
        }
      ]
  })

  vars = {
    ssm_resource_arn     = local.ssm_resource_arn
    secrets_resource_arn = local.secrets_resource_arn
  }
}

# task policy
resource "aws_iam_policy" "ecs_task" {
  name        = "${local.ecs_name_prefix}-task-policy"
  description = "ecs task policy for ${local.ecs_name_prefix}"
  path        = "/"

  policy = data.template_file.ecs_task_policy.rendered
}

resource "aws_iam_policy" "ecs_execution" {
  name        = "${local.ecs_name_prefix}-execution-policy"
  description = "task execution policy for ${local.ecs_name_prefix}"
  path        = "/"

  policy = data.template_file.ecs_execution_policy.rendered
}

# task role
resource "aws_iam_role" "ecs_task" {
  name        = "${local.ecs_name_prefix}-task-role"
  description = "task role for ${local.ecs_name_prefix}"

  assume_role_policy = local.assume_role_policy_ecs_tasks

  tags = merge({ Policy = aws_iam_policy.ecs_task.name }, local.tags)
}

resource "aws_iam_role_policy_attachment" "ecs_task" {
  role       = aws_iam_role.ecs_task.id
  policy_arn = aws_iam_policy.ecs_task.arn
}

# execution role
resource "aws_iam_role" "ecs_execution" {
  name        = "${local.ecs_name_prefix}-execution-role"
  description = "task execution role for ${local.ecs_name_prefix}"

  assume_role_policy = local.assume_role_policy_ecs_tasks

  tags = merge({ Policy = aws_iam_policy.ecs_execution.name }, local.tags)
}

resource "aws_iam_role_policy_attachment" "ecs_execution_policy" {
  role       = aws_iam_role.ecs_execution.id
  policy_arn = aws_iam_policy.ecs_execution.arn
}

resource "aws_iam_role_policy_attachment" "ecs_execution_managed_policy" {
  role       = aws_iam_role.ecs_execution.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# autoscaling role
resource "aws_iam_role" "ecs_autoscaling" {
  name               = "${local.ecs_name_prefix}-autoscaling-role"
  description        = "autoscaling role for ${local.ecs_name_prefix}"
  assume_role_policy = local.assume_role_policy_ecs_tasks

  tags = merge({ Policy = "" }, local.tags)
}

resource "aws_iam_role_policy_attachment" "ecs_autoscaling_managed_policy" {
  role       = aws_iam_role.ecs_autoscaling.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceAutoscaleRole"
}
