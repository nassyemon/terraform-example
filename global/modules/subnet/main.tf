# Module that allows creating a subnet inside a VPC. This module can be used to create
# either a private or public-facing subnet.

resource aws_subnet subnet {
  vpc_id            = var.vpc_id
  cidr_block        = element(var.cidrs, count.index)
  availability_zone = element(var.availability_zones, count.index)
  count             = length(var.cidrs)

  tags = {
    Name        = "${var.network_env}-${var.name}-${element(var.availability_zones, count.index)}"
    Environment = var.network_env
  }
}
