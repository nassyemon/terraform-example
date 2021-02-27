output "cert_arn" {
  value = aws_acm_certificate.cert.arn
}

output "arn" {
  value = aws_alb.alb.arn
}

output "target_group_arn" {
  value      = aws_alb_target_group.alb.arn
  depends_on = [aws_alb_target_group.alb]
}