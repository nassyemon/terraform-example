locals {
  operation_server_name  =  "${local.sg_prefix}-operation-server"
}

resource aws_security_group operation_server {
  name = local.operation_server_name
  description = "security group for ${local.operation_server_name}"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}