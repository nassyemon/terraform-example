locals {
  operation_server_name =  "${var.project}-${var.env}-operation-server"
  instance_connect_name = "${local.operation_server_name}-instance-connect"
  tags = {
    Env = var.env
    Project = var.project
  }
}

data aws_ami operation_server {
  most_recent = true
  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.20190618-x86_64-ebs"]
  }
}

resource aws_instance operation_server {
  ami                         = data.aws_ami.operation_server.id
  instance_type               = "t3.micro"
  subnet_id                   = var.public_subnet_id
  associate_public_ip_address = true

  root_block_device {
    volume_type = "gp3"
    volume_size = 20
    delete_on_termination = true
  }

  vpc_security_group_ids = var.sg_operation_server_ids

  iam_instance_profile = aws_iam_instance_profile.instance_connect.name

  tags        = merge({ Name = local.operation_server_name }, local.tags)
  volume_tags = merge({ Name = local.operation_server_name }, local.tags)

  user_data = <<EOF
#!/bin/bash
yum update -y -q
yum install ec2-instance-connect
EOF
}