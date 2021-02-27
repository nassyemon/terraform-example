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
  operation_server = (
    var.network_env == "production_network" ?
    data.terraform_remote_state.global.outputs.production_operation_server
    : data.terraform_remote_state.global.outputs.development_operation_server
  )
  ssm_base_path             = "/${var.project}/${var.env}"
  ecr_csweb                 = data.terraform_remote_state.global.outputs.ecr_csweb
  ecr_admweb                = data.terraform_remote_state.global.outputs.ecr_admweb
  ecr_migrate               = data.terraform_remote_state.global.outputs.ecr_migrate
  operation_server_username = data.terraform_remote_state.global.outputs.operation_server_username
  vpc_id                    = local.network.vpc_id
  public_subnet_ids         = local.network.public_subnet_ids
  webapp_subnet_ids         = local.network.webapp_subnet_ids
  database_subnet_ids       = local.network.database_subnet_ids
}
