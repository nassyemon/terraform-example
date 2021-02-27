locals {
  csweb_domain_name = "${var.subdomain_csweb}.${var.hosted_zone_name}"
  alb_csweb_name    = "${var.project}-${var.env}-csweb"
}

data "aws_route53_zone" "hosted" {
  zone_id = var.hosted_zone_id
}

#acm cert
resource "aws_acm_certificate" "csweb" {
  domain_name       = local.csweb_domain_name
  validation_method = "DNS"
  tags = {
    Env     = var.env
    Project = var.project
    Name    = local.csweb_domain_name
  }
}

resource "aws_route53_record" "csweb_cert_validation" {
  allow_overwrite = true
  zone_id         = data.aws_route53_zone.hosted.zone_id
  ttl             = 60

  for_each = {
    for dvo in aws_acm_certificate.csweb.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  name    = each.value.name
  records = [each.value.record]
  type    = each.value.type
}

resource "aws_acm_certificate_validation" "csweb" {
  certificate_arn         = aws_acm_certificate.csweb.arn
  validation_record_fqdns = values(aws_route53_record.csweb_cert_validation)[*].fqdn
}

# csweb-alb
resource "aws_alb" "csweb" {
  name            = local.alb_csweb_name
  subnets         = var.public_subnet_ids
  security_groups = var.sg_alb_csweb_ids

  load_balancer_type         = "application"
  internal                   = false
  enable_deletion_protection = false
  enable_http2               = false
  ip_address_type            = "ipv4"

  idle_timeout = "60"

  # access_logs {
  #   bucket  = var.s3_csweb_logs_bucket
  #   prefix  = "csweb-alb"
  #   enabled = true
  # }

  tags = {
    Name    = local.alb_csweb_name
    Env     = var.env
    Project = var.project
  }
}

# http listner (always redirect)
resource "aws_alb_listener" "csweb_http" {
  load_balancer_arn = aws_alb.csweb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# https listner
resource "aws_alb_listener" "csweb_https" {
  load_balancer_arn = aws_alb.csweb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate_validation.csweb.certificate_arn
  default_action {
    target_group_arn = aws_alb_target_group.csweb.arn
    type             = "forward"

    # type = "fixed-response"
    # fixed_response {
    #   content_type = "text/plain"
    #   message_body = "test content"
    #   status_code  = "200"
    # }
  }

  # lifecycle {
  #   ignore_changes = [default_action]
  # }
  depends_on = [aws_alb.csweb]
}

# route53 record
resource "aws_route53_record" "csweb" {
  zone_id = data.aws_route53_zone.hosted.zone_id
  name    = local.csweb_domain_name
  type    = "A"

  alias {
    name                   = aws_alb.csweb.dns_name
    zone_id                = aws_alb.csweb.zone_id
    evaluate_target_health = false
    # evaluate_target_health = true
  }
}

# target group
resource "aws_alb_target_group" "csweb" {
  name                 = "${local.alb_csweb_name}-tg"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  deregistration_delay = 60 # TODO.
  target_type          = "ip"

  health_check {
    path     = var.csweb_app_health_check_path
    protocol = "HTTP"
    # port = 80
    interval            = 10
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name    = local.alb_csweb_name
    Env     = var.env
    Project = var.project
  }
}
