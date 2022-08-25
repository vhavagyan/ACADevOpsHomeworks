output "ec2_public_ip" {
  value = aws_instance.srv_ops.public_ip
}

output "cloudfront_dist_aliases" {
  value = aws_cloudfront_distribution.cloudfront_lb_distribution.aliases
}
