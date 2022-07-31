resource "aws_s3_bucket" "srv_nginx_s3bucket" {
  bucket = "srv-nginx-s3bucket"

   tags = {
     Name = "nginx server site s3 bucket",
     PROJECT = var.project_name
  }
}

resource "aws_s3_bucket_acl" "srv_nginx_s3bucket_acl" {
  bucket = aws_s3_bucket.srv_nginx_s3bucket.id
  acl    = "private"
}