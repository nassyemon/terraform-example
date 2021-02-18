output csweb_cert_arn {
  value = aws_acm_certificate.csweb.arn
}

output csweb_arn {
  value = aws_alb.csweb.arn
}

output target_group_csweb_arn {
  value = aws_alb_target_group.csweb.arn
}