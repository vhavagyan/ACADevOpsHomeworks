
output "cloudfront_dist_aliases" {
  value = aws_cloudfront_distribution.cloudfront_lb_distribution.aliases
}
