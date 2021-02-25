data "aws_instance" "operation_server" {
  instance_id = var.instance_id
}

locals {
  remote_dir          = "/home/${var.os_username}/provisioning/${var.project}/${var.env}"
  files_dir           = "${path.module}/files"
  templates_dir       = "${path.module}/.templates" # avoid being processed by terraform fmt
  temp_dir            = "${path.module}/.temp"
  username            = var.os_username
  instance_id         = data.aws_instance.operation_server.instance_id
  ssh_key_name_prefix = "${local.instance_id}-ssh"
  ssh_key_name        = "${local.ssh_key_name_prefix}-${timestamp()}"
  public_ip           = data.aws_instance.operation_server.public_ip
  availability_zone   = data.aws_instance.operation_server.availability_zone

  files      = [for filepath in fileset(local.files_dir, "**") : "${local.files_dir}/${filepath}"]
  templates  = [for filepath in fileset(local.templates_dir, "**") : "${local.templates_dir}/${filepath}"]
  hash_files = md5(join("-", [for filepath in concat(local.files, local.templates) : filemd5(filepath)]))
  template_vars = {
    aws_region                       = data.aws_region.current.name,
    rds_identifier                   = var.rds_identifier
    env                              = var.env
    endpoint                         = var.rds_endpoint
    root_username                    = var.rds_username
    root_password_secrets_arn        = var.rds_password_secrets_arn
    appdb_username                   = var.rds_appdb_username
    appdb_name                       = var.rds_appdb_name
    appdb_username_ssm_path          = "${var.ssm_base_path}/rds/appdb_username"
    appdb_user_password_secrets_path = "${var.ssm_base_path}/rds/appdb_user_password"
  }
}



resource "null_resource" "init_temp_dir" {
  triggers = {
    hash        = local.hash_files
    instance_id = local.instance_id
    vars        = jsonencode(local.template_vars)
  }

  provisioner "local-exec" {
    command = <<EOT
rm -rf ${local.temp_dir}
mkdir -p ${local.temp_dir}
EOT
  }
}

resource "template_dir" "templates" {
  source_dir      = local.templates_dir
  destination_dir = local.temp_dir

  vars       = local.template_vars
  depends_on = [null_resource.init_temp_dir]
}

resource "null_resource" "copy_files" {
  triggers = {
    previsous = null_resource.init_temp_dir.id
  }
  provisioner "local-exec" {
    command = "cp -r ${local.files_dir}/ ${local.temp_dir}"
  }
  depends_on = [template_dir.templates]
}

resource "null_resource" "put_ssh_key" {
  triggers = {
    previous = null_resource.init_temp_dir.id
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

  depends_on = [template_dir.templates, null_resource.copy_files]
}

resource "null_resource" "upload_files" {
  triggers = {
    previous = null_resource.copy_files.id
  }

  provisioner "remote-exec" {
    inline = [
      "set -x",
      "rm -rf ${local.remote_dir}/*",
      "mkdir -p ${local.remote_dir}"
    ]
  }

  provisioner "file" {
    source      = "${local.temp_dir}/"
    destination = local.remote_dir
  }

  provisioner "remote-exec" {
    inline = [
      "set -x",
      "cd ${local.remote_dir} && pwd",
      "terraform init -reconfigure",
      "terraform plan",
      "terraform apply -auto-approve",
    ]
    on_failure = continue
  }

  connection {
    type        = "ssh"
    host        = local.public_ip
    user        = local.username
    private_key = try(file("${path.root}/.temp/${local.ssh_key_name}"), null)
  }

  depends_on = [null_resource.put_ssh_key]
}

resource "null_resource" "clean_up" {
  triggers = {
    previous = null_resource.upload_files.id
  }
  provisioner "local-exec" {
    command     = <<EOT
rm -f ${local.ssh_key_name} ${local.ssh_key_name}.pub
EOT
    working_dir = "${path.root}/.temp"
  }
  depends_on = [null_resource.upload_files]
}
