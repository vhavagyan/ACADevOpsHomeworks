output "ec2_public_ip" {
  value = aws_instance.srv_nginx.public_ip
}

output "cloudfront_dist_aliases" {
  value = aws_cloudfront_distribution.cloudfront_s3_distribution.aliases
}
