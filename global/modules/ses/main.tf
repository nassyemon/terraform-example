resource "aws_ses_domain_identity" "ses" {
  domain = var.hosted_zone_name
}

resource "aws_route53_record" "identity_record" {
  zone_id = var.hosted_zone_id
  name    = "_amazonses.${aws_ses_domain_identity.ses.id}"
  type    = "TXT"
  ttl     = "600"
  records = [aws_ses_domain_identity.ses.verification_token]
}

resource "aws_ses_domain_identity_verification" "ses" {
  domain = aws_ses_domain_identity.ses.id

  depends_on = [aws_route53_record.identity_record]
}

resource "aws_ses_domain_dkim" "dkim" {
  domain = aws_ses_domain_identity.ses.domain
}

resource "aws_route53_record" "dkim_record" {
  count   = 3
  zone_id = var.hosted_zone_id
  name    = "${element(aws_ses_domain_dkim.dkim.dkim_tokens, count.index)}._domainkey"
  type    = "CNAME"
  ttl     = "600"
  records = ["${element(aws_ses_domain_dkim.dkim.dkim_tokens, count.index)}.dkim.amazonses.com"]
}
