locals {
  alb_csweb_name = "${local.sg_prefix}-alb-csweb"
  ecs_csweb_name = "${local.sg_prefix}-ecs-csweb"
}

resource "aws_security_group" "alb_csweb" {
  name        = local.alb_csweb_name
  description = "security group for ${local.alb_csweb_name}"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.csweb_alb_ingress_cidrs
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.csweb_alb_ingress_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = data.aws_subnet.webapp_subnet.*.cidr_block
  }

  tags = merge({ Name = local.alb_csweb_name }, local.tags)
}

resource "aws_security_group" "ecs_csweb" {
  name        = local.ecs_csweb_name
  description = "security group for ${local.ecs_csweb_name}"
  vpc_id      = var.vpc_id

  # http from alb
  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    security_groups = [
      var.sg_operation_server_id,
      aws_security_group.alb_csweb.id,
    ]
  }

  # anywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({ Name = local.ecs_csweb_name }, local.tags)
}
