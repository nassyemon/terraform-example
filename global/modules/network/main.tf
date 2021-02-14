module "vpc" {
  source = "../vpc"

  aws_vpc_cidr = var.aws_vpc_cidr
  aws_vpc_tags_name = var.aws_vpc_tags_name
  network_env = var.network_env
}

module "webapp_subnet" {
  source = "../subnet"

  name               = "webapp-subnet"
  network_env        = var.network_env
  vpc_id             = module.vpc.id
  cidrs              = var.webapp_subnet_cidrs
  availability_zones = var.availability_zones
}

module "database_subnet" {
  source = "../subnet"

  name               = "database-subnet"
  network_env        = var.network_env
  vpc_id             = module.vpc.id
  cidrs              = var.database_subnet_cidrs
  availability_zones = var.availability_zones
}

module "public_subnet" {
  source = "../subnet"

  name               = "public-subnet"
  network_env        = var.network_env
  vpc_id             = module.vpc.id
  cidrs              = var.public_subnet_cidrs
  availability_zones = var.availability_zones
}

module "nat" {
  source = "../nat_gateway"

  subnet_ids   = module.public_subnet.ids
  network_env        = var.network_env
  subnet_count = length(var.public_subnet_cidrs)
  availability_zones = var.availability_zones
}

resource "aws_route" "public_igw_route" {
  route_table_id         = element(module.public_subnet.route_table_ids, count.index)
  gateway_id             = module.vpc.igw
  destination_cidr_block = var.destination_cidr_block

  count                  = length(var.public_subnet_cidrs)
}

resource "aws_route" "webapp_nat_route" {
  route_table_id         = element(module.webapp_subnet.route_table_ids, count.index)
  nat_gateway_id         = element(module.nat.ids, count.index)
  destination_cidr_block = var.destination_cidr_block

  count                  = length(var.webapp_subnet_cidrs)
}

# Creating a NAT Gateway takes some time. Some services need the internet (NAT Gateway) before proceeding. 
# Therefore we need a way to depend on the NAT Gateway in Terraform and wait until is finished. 
# Currently Terraform does not allow module dependency to wait on.
# Therefore we use a workaround described here: https://github.com/hashicorp/terraform/issues/1178#issuecomment-207369534

resource "null_resource" "dummy_dependency" {
  depends_on = [module.nat]
}
