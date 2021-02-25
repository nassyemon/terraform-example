locals {
  rds_identifier = "${var.project}-${var.env}-rds"
}

# Create RDSinstance
resource "aws_db_instance" "rds" {
  identifier                = local.rds_identifier
  allocated_storage         = var.allocated_storage
  storage_type              = var.storage_class
  engine                    = "mysql"
  engine_version            = "8.0.21"
  instance_class            = var.instance_class
  name                      = var.name
  username                  = var.username
  password                  = random_password.password.result
  port                      = var.port
  publicly_accessible       = false
  security_group_names      = []
  vpc_security_group_ids    = var.rds_security_group_ids
  db_subnet_group_name      = aws_db_subnet_group.rds.id
  parameter_group_name      = aws_db_parameter_group.rds.name
  multi_az                  = var.multi_az
  backup_retention_period   = 0
  backup_window             = var.backup_window
  maintenance_window        = var.maintenance_window
  final_snapshot_identifier = "${local.rds_identifier}-final"

  tags = {
    Name  = local.rds_identifier
    Group = var.project
    Env   = var.env
  }

  lifecycle {
    ignore_changes = [password]
  }
}

# Parameter Group for rds
resource "aws_db_parameter_group" "rds" {
  name        = "${local.rds_identifier}-pg"
  family      = "mysql8.0"
  description = "RDS parameter group for ${local.rds_identifier}"

  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8"
  }
}

# Subnet Group for mysql
resource "aws_db_subnet_group" "rds" {
  name        = "${local.rds_identifier}-subnet-group"
  description = "subnet group for ${local.rds_identifier}"
  subnet_ids  = var.database_subnet_ids
  tags = {
    Name = "${local.rds_identifier} subnet group"
    Env  = var.env
  }
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}
