resource "aws_route53_record" "route53_record_cfdistribution" {
  zone_id = var.route53HostedZoneID
  name    = var.route53HostedZoneDN
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cloudfront_lb_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.cloudfront_lb_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "route53_record_certvalidation" {
  for_each = {
    for dvo in aws_acm_certificate.cert_for_cloudfront.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.route53HostedZoneID
}