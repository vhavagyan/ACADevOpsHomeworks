resource "aws_acm_certificate" "cert_for_cloudfront" {
    domain_name = var.route53HostedZoneDN
    validation_method = "DNS"

    lifecycle {
      create_before_destroy = true
  }

  tags = {
     Name = "certificate for cloudfront distribution for site",
     PROJECT = var.project_name
  }

}

resource "aws_acm_certificate_validation" "cert_validation_for_cloudfront" {
  certificate_arn         = aws_acm_certificate.cert_for_cloudfront.arn
  validation_record_fqdns = [for record in aws_route53_record.route53_record_certvalidation : record.fqdn]
}