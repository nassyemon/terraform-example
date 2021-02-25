data "aws_region" "current" {}

locals {
  scripts_dir         = "${path.module}/scripts"
  username            = var.os_username
  instance_id         = aws_instance.operation_server.id
  ssh_key_name_prefix = "${local.instance_id}-ssh"
  ssh_key_name        = "${local.ssh_key_name_prefix}-${timestamp()}"
  public_ip           = aws_instance.operation_server.public_ip
  availability_zone   = aws_instance.operation_server.availability_zone

  scripts      = [for file in fileset(local.scripts_dir, "*.sh") : "${local.scripts_dir}/${file}"]
  hash_scripts = md5(join("-", [for filepath in local.scripts : filemd5(filepath)]))
}

resource "null_resource" "put_ssh_key" {
  triggers = {
    hash        = local.hash_scripts,
    instance_id = local.instance_id
  }

  provisioner "local-exec" {
    command     = <<EOT
rm -f ${local.ssh_key_name_prefix}*

ssh-keygen -t rsa -f ${local.ssh_key_name} -q -N ''

aws ec2-instance-connect send-ssh-public-key \
--region ${data.aws_region.current.name} \
--instance-id ${local.instance_id} \
--availability-zone ${local.availability_zone} \
--instance-os-user ${local.username} \
--ssh-public-key file://${local.ssh_key_name}.pub

EOT
    working_dir = "${path.root}/.temp"
  }
}

resource "null_resource" "provision" {
  triggers = {
    previous = null_resource.put_ssh_key.id
  }
  provisioner "remote-exec" {
    scripts = local.scripts
  }

  connection {
    type        = "ssh"
    host        = local.public_ip
    user        = local.username
    private_key = file("${path.root}/.temp/${local.ssh_key_name}")
  }

  depends_on = [null_resource.put_ssh_key]
}

resource "null_resource" "clean_up" {
  triggers = {
    previous = null_resource.provision.id
  }
  provisioner "local-exec" {
    command     = <<EOT
rm -f ${local.ssh_key_name} ${local.ssh_key_name}.pub
EOT
    working_dir = "${path.root}/.temp"
  }
  depends_on = [null_resource.provision]
}
