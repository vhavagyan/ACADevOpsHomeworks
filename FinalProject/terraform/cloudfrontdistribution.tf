resource "aws_cloudfront_distribution" "cloudfront_lb_distribution" {
  origin {
    domain_name = aws_lb.eks_lb.dns_name
    origin_id   = aws_lb.eks_lb.id

    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  aliases = ["${var.route53HostedZoneDN}"]

  enabled             = true
  is_ipv6_enabled     = false
  comment             = ""

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_lb.eks_lb.id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.cert_for_cloudfront.arn
    ssl_support_method = "sni-only"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  tags = {
     Name = "cloudfront distribution for load balancer",
     PROJECT = var.project_name
  }
}
