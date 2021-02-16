output external_alb_cert_arn {
  value = aws_acm_certificate.external_alb.arn
}

output external_alb_arn {
  value = aws_alb.external_alb.arn
}