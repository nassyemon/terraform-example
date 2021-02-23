
data "terraform_remote_state" "self" {
  backend = "s3"

  config = {
    bucket = var.be_bucket
    key    = var.be_key
    region = var.be_region
  }
}

locals {
  last_state_production_operation_server  = try(data.terraform_remote_state.self.outputs.production_operation_server, map({}))
  last_state_development_operation_server = try(data.terraform_remote_state.self.outputs.development_operation_server, map({}))

  production_operation_server_last_provision_timestamp  = try(local.last_state_production_operation_server.last_provision_timestamp, null)
  development_operation_server_last_provision_timestamp = try(local.last_state_development_operation_server.last_provision_timestamp, null)
}