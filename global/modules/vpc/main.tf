resource aws_vpc vpc {
  cidr_block           = var.aws_vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = false

  tags = {
    Name = "${var.network_env}-${var.aws_vpc_tags_name}"
  }
}

resource aws_internet_gateway vpc {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.network_env}-${var.aws_vpc_tags_name}-igw"
    Environment = var.network_env
  }
}