resource "aws_cloudfront_distribution" "cloudfront_s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.srv_nginx_s3bucket.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.srv_nginx_s3bucket.id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.cloudfront_origin_ai.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = false
  comment             = ""
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.srv_nginx_s3bucket.id

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
    cloudfront_default_certificate = true
  }

  custom_error_response {
    error_code = 404
    response_code = 200
    response_page_path = "/index.html"
  }
  
  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  tags = {
     Name = "cloudfront distribution for Jul31 site",
     PROJECT = var.project_name
  }
}

resource "aws_cloudfront_origin_access_identity" "cloudfront_origin_ai" {
  comment = "Access identity for S3 origin"
}
