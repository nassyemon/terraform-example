locals {
  sg_prefix =  "${var.project}-${var.env}"
  external_alb_name = "${local.sg_prefix}-external-alb"
  webapp_name = "${local.sg_prefix}-webapp"
  rds_name = "${local.sg_prefix}-rds"
}

resource "aws_security_group" "external_alb" {
    name = local.external_alb_name
    description = "security group for ${local.external_alb_name}"
    vpc_id = var.vpc_id

    # Only allows https
    ingress {
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Env = var.env
      Name = local.external_alb_name
    }
}

resource "aws_security_group" "webapp" {
    name = local.webapp_name
    description = "security group for ${local.webapp_name}"
    vpc_id = var.vpc_id

    # http from alb
    ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      security_groups = [aws_security_group.external_alb.id]
    }

    # anywhere
    egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Env = var.env
      Name = local.webapp_name
    }
}

resource "aws_security_group" "rds" {
    name = local.rds_name
    description = "security group for ${local.rds_name}"
    vpc_id = var.vpc_id

    # http from alb
    ingress {
      from_port = var.rds_port
      to_port = var.rds_port
      protocol = "tcp"
      security_groups = [aws_security_group.webapp.id]
    }

    # anywhere
    egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Env = var.env
      Name = local.rds_name
    }
}