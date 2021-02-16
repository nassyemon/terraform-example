locals {
  assume_role_policy_ecs_tasks = jsonencode(
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": ["ecs-tasks.amazonaws.com"]
      },
      "Action": "sts:AssumeRole"
    }
  ]
})
}

data template_file webapp_task_policy {
  template = jsonencode(
{
    "Version": "2012-10-17",
    "Statement": [
    {
      "Action": ["logs:*"],
      "Effect": "Allow",
      "Resource": "$${ecs_log_group}"
    }
  ]
})

  vars = {
    ecs_log_group = local.ecs_log_group
  }
}

data template_file ecs_execution_policy {
  template = jsonencode(
{
    "Version": "2012-10-17",
    "Statement": [
    {
      "Action": ["ssm:DescribeParameters"],
      "Effect": "Allow",
      "Resource": "*"
    },
    {
      "Action": ["ssm:GetParameters"],
      "Effect": "Allow",
      "Resource": "$${ssm_parameter_path}"
    }
  ]
})

  vars = {
    ssm_parameter_path = local.ssm_parameter_path
  }
}

# task role
resource aws_iam_policy webapp_task {
  name = "${local.webapp_family}-webapp-task-policy"
  description = "task policy for ${local.webapp_family}"
  path = "/"

  policy = data.template_file.webapp_task_policy.rendered
}

resource aws_iam_policy ecs_execution {
  name = "${var.project}-${var.env}-ecs-execution-policy"
  description = "task execution policy for ${var.project}-${var.env}"
  path = "/"

  policy = data.template_file.ecs_execution_policy.rendered
}

# task policy
resource aws_iam_role webapp_task {
  name = "${local.webapp_family}-webapp-task-role"
  description = "task role for ${local.webapp_family}"

  assume_role_policy = local.assume_role_policy_ecs_tasks

  tags = {
    Env = var.env
    Project = var.project
    Policy = aws_iam_policy.webapp_task.name
    Management = "Terraform"
  }
}

resource aws_iam_role_policy_attachment webapp_task {
  role       = aws_iam_role.webapp_task.name
  policy_arn = aws_iam_policy.webapp_task.arn
}


resource aws_iam_role ecs_execution {
  name = "${var.project}-${var.env}-ecs-execution-role"
  description = "task execution role for ${var.project}-${var.env}"

  assume_role_policy = local.assume_role_policy_ecs_tasks

  tags = {
    Env = var.env
    Project = var.project
    Policy = aws_iam_policy.ecs_execution.name
    Management = "Terraform"
  }
}

resource aws_iam_role_policy_attachment ecs_execution {
  role       = aws_iam_role.ecs_execution.name
  for_each   =  toset([
    aws_iam_policy.ecs_execution.arn,
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  ])
  policy_arn = each.value
}
