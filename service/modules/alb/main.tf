locals {
  domain_name = "${var.subdomain}.${var.hosted_zone_name}"
  alb_name    = "${var.project}-${var.env}-${var.subdomain}"
}

data "aws_route53_zone" "hosted" {
  zone_id = var.hosted_zone_id
}

#acm cert
resource "aws_acm_certificate" "cert" {
  domain_name       = local.domain_name
  validation_method = "DNS"
  tags = {
    Env     = var.env
    Project = var.project
    Name    = local.domain_name
  }
}

resource "aws_route53_record" "cert" {
  allow_overwrite = true
  zone_id         = data.aws_route53_zone.hosted.zone_id
  ttl             = 60

  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  name    = each.value.name
  records = [each.value.record]
  type    = each.value.type
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = values(aws_route53_record.cert)[*].fqdn
}

# alb
resource "aws_alb" "alb" {
  name            = local.alb_name
  subnets         = var.subnet_ids
  security_groups = var.sg_alb_ids

  load_balancer_type         = "application"
  internal                   = var.internal
  enable_deletion_protection = false
  enable_http2               = true
  ip_address_type            = "ipv4"

  idle_timeout = "60"

  # access_logs {
  #   bucket  = var.s3_logs_bucket
  #   prefix  = "alb"
  #   enabled = true
  # }

  tags = {
    Name       = local.alb_name
    Env        = var.env
    Project    = var.project
    Management = "Terraform"
  }
}

# http listner (always redirect)
resource "aws_alb_listener" "http" {
  count = var.listen_http ? 1 : 0

  load_balancer_arn = aws_alb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  dynamic "default_action" {
    for_each = var.redirect_https ? [true] : []
    content {
      type = "redirect"
      redirect {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  }

  dynamic "default_action" {
    for_each = var.redirect_https ? [] : [true]
    content {
      target_group_arn = aws_alb_target_group.alb.arn
      type             = "forward"
    }
  }

  # lifecycle {
  #   ignore_changes = [default_action]
  # }
}

# https listner
resource "aws_alb_listener" "https" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate_validation.cert.certificate_arn
  default_action {
    target_group_arn = aws_alb_target_group.alb.arn
    type             = "forward"
  }

  # default_action {
  #   type = "fixed-response"
  #   fixed_response {
  #     content_type = "text/plain"
  #     message_body = "test content"
  #     status_code  = "200"
  #   }
  # }

  # lifecycle {
  #   ignore_changes = [default_action]
  # }
  depends_on = [aws_alb.alb]
}

# route53 record
resource "aws_route53_record" "alb" {
  zone_id = data.aws_route53_zone.hosted.zone_id
  name    = local.domain_name
  type    = "A"

  alias {
    name                   = aws_alb.alb.dns_name
    zone_id                = aws_alb.alb.zone_id
    evaluate_target_health = false
    # evaluate_target_health = true
  }
}

# target group
resource "aws_alb_target_group" "alb" {
  name                 = "${local.alb_name}-tg"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  deregistration_delay = 60 # TODO.
  target_type          = "ip"

  health_check {
    path     = var.health_check_path
    protocol = "HTTP"
    # port = 80
    interval            = 10
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name       = local.alb_name
    Env        = var.env
    Project    = var.project
    Management = "Terraform"
  }

  depends_on = [aws_alb.alb]
}
