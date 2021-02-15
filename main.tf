data "terraform_remote_state" "global" {
  backend = "s3"

  config = {
    bucket = var.global_be_bucket
    key    = var.global_be_key
    region = var.global_be_region
  }
}

locals {
  network = (
    var.network_env == "production_network" ?
      data.terraform_remote_state.global.outputs.production_network
    : data.terraform_remote_state.global.outputs.development_network
  )
  vpc_id = local.network.vpc_id
  public_subnet_ids = local.network.public_subnet_ids
  webapp_subnet_ids = local.network.webapp_subnet_ids
  database_subnet_ids = local.network.database_subnet_ids
}

module "security_group" {
  source = "./modules/security_group"
  env = var.env
  project = var.project
  vpc_id = local.vpc_id
  rds_port = 3306
}

module "rds" {
  source = "./modules/rds"

  env = var.env
  project = var.project
  name = var.rds_name
  database_subnet_ids = local.network.database_subnet_ids
  rds_security_group_ids = [module.security_group.rds_id]
  port = 3306
  username = var.rds_username
  instance_class = var.rds_instance_params.instance_class
  allocated_storage = var.rds_instance_params.allocated_storage
  storage_class = var.rds_instance_params.storage_class
  multi_az = var.rds_instance_params.multi_az
  backup_window = var.rds_instance_params.backup_window
  maintenance_window = var.rds_instance_params.maintenance_window

  disabled = var.disabled
}
