locals {
  operation_server_name = "${var.network_env}-operation-server"
  instance_connect_name = "${local.operation_server_name}-instance-connect"
  tags = {
    NetworkEnv = var.network_env
  }
}

data "aws_ami" "operation_server" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-groovy-20.10-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "operation_server" {
  ami                         = data.aws_ami.operation_server.id
  instance_type               = "t3.micro"
  subnet_id                   = var.public_subnet_id
  associate_public_ip_address = true

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 20
    delete_on_termination = true
  }

  vpc_security_group_ids = [aws_security_group.operation_server.id]

  iam_instance_profile = aws_iam_instance_profile.operation_server.name

  tags        = merge({ Name = local.operation_server_name }, local.tags)
  volume_tags = merge({ Name = local.operation_server_name }, local.tags)

  user_data = <<EOF
#!/bin/bash
apt -y update
apt -y upgrade
apt -y install ec2-instance-connect
apt -y install python
EOF
}