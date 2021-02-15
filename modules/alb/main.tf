locals {
  domain_name = "${var.subdomain_external_alb}.${var.hosted_zone_name}"
}

data aws_route53_zone external_alb {
  zone_id         = var.hosted_zone_id
}

#acm cert
resource aws_acm_certificate external_alb {
  domain_name       = local.domain_name
  validation_method = "DNS"
  tags = {
    Env        = var.env
    Project    = var.project
    Name       = local.domain_name
  }
}

resource aws_route53_record external_alb_cert_validation {
  allow_overwrite = true
  zone_id = data.aws_route53_zone.external_alb.zone_id
  ttl             = 60

  for_each = {
    for dvo in aws_acm_certificate.external_alb.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  name            = each.value.name
  records         = [each.value.record]
  type            = each.value.type
}

resource aws_acm_certificate_validation external_alb {
  certificate_arn         = aws_acm_certificate.external_alb.arn
  validation_record_fqdns = values(aws_route53_record.external_alb_cert_validation)[*].fqdn
}