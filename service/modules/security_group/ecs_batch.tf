locals {
  ecs_batch_general_name = "${local.sg_prefix}-ecs-batch-general"
}

resource "aws_security_group" "ecs_batch_general" {
  name        = local.ecs_batch_general_name
  description = "security group for ${local.ecs_batch_general_name}"
  vpc_id      = var.vpc_id

  # anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({ Name = local.ecs_batch_general_name }, local.tags)
}
