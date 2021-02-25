# Using the AWS NAT Gateway service instead of a nat instance, it's more expensive but easier
# See comparison http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/vpc-nat-comparison.html

resource "aws_nat_gateway" "nat" {
  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id     = element(var.subnet_ids, count.index)
  tags = {
    Name       = "${var.network_env}-nat-${element(var.availability_zones, count.index)}"
    NetworkEnv = var.network_env
  }
  count = var.disabled ? 0 : (var.use_single_nat_gateway ? 1 : var.subnet_count)
}

resource "aws_eip" "nat" {
  vpc   = true
  count = var.disabled ? 0 : var.subnet_count
}