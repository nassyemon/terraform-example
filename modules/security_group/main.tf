locals {
  sg_prefix =  "${var.project}-${var.env}"
  alb_csweb_name = "${local.sg_prefix}-alb-csweb"
  ecs_csweb_name = "${local.sg_prefix}-ecs-csweb"
  rds_name = "${local.sg_prefix}-rds"
}

data "aws_subnet" "webapp_subnet" {
  id = element(var.webapp_subnet_ids, count.index)
  count         = length(var.webapp_subnet_ids)
}

resource aws_security_group alb_csweb {
    name = local.alb_csweb_name
    description = "security group for ${local.alb_csweb_name}"
    vpc_id = var.vpc_id

    ingress {
      from_port = 443
      to_port = 443
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = data.aws_subnet.webapp_subnet.*.cidr_block
    }

    tags = {
      Env = var.env
      Project = var.project
      Name = local.alb_csweb_name
    }
}

resource aws_security_group ecs_csweb {
    name = local.ecs_csweb_name
    description = "security group for ${local.ecs_csweb_name}"
    vpc_id = var.vpc_id

    # http from alb
    ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      security_groups = [
        var.sg_operation_server_id,
        aws_security_group.alb_csweb.id,
      ]
    }

    # docker ephemeral ports
    # ingress {
    #   from_port = 32768
    #   to_port = 61000
    #   protocol = "tcp"
    #   security_groups = [aws_security_group.alb_csweb.id]
    # }

    # anywhere
    egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Env = var.env
      Project = var.project
      Name = local.ecs_csweb_name
    }
}

resource aws_security_group rds {
    name = local.rds_name
    description = "security group for ${local.rds_name}"
    vpc_id = var.vpc_id

    # http from alb
    ingress {
      from_port = var.rds_port
      to_port = var.rds_port
      protocol = "tcp"
      security_groups = [
        var.sg_operation_server_id,
        aws_security_group.ecs_csweb.id,
      ]
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
      Project = var.project
      Name = local.rds_name
    }
}