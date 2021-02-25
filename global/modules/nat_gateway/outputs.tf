output "ids" {
  value = aws_nat_gateway.nat.*.id
}

output "disabled" {
  value = length(aws_nat_gateway.nat) > 0 ? false : true
}