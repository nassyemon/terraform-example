locals {
  sg_prefix = "${var.project}-${var.env}"
  rds_name  = "${local.sg_prefix}-rds"
  tags = {
    Env        = var.env
    Project    = var.project
    Management = "Terraform"
  }
}

data "aws_subnet" "webapp_subnet" {
  id    = element(var.webapp_subnet_ids, count.index)
  count = length(var.webapp_subnet_ids)
}

resource "aws_security_group" "rds" {
  name        = local.rds_name
  description = "security group for ${local.rds_name}"
  vpc_id      = var.vpc_id

  # http from alb
  ingress {
    from_port = var.rds_port
    to_port   = var.rds_port
    protocol  = "tcp"
    security_groups = [
      var.sg_operation_server_id,
      aws_security_group.ecs_csweb.id,
      aws_security_group.ecs_admweb.id,
      aws_security_group.ecs_batch_general.id,
    ]
  }

  # anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({ Name = local.rds_name }, local.tags)
}