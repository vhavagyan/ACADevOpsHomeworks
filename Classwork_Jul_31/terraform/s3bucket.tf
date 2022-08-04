resource "aws_s3_bucket" "srv_nginx_s3bucket" {
  bucket = "srv-nginx-s3bucket"

   tags = {
     Name = "nginx server site s3 bucket",
     PROJECT = var.project_name
  }
}

resource "aws_s3_object" "s3_object_indexhtml" {
  bucket = aws_s3_bucket.srv_nginx_s3bucket.id
  key    = "index.html"
  source = "../external/index.html"
  content_type = "text/html"
}

resource "aws_s3_bucket_acl" "srv_nginx_s3bucket_acl" {
  bucket = aws_s3_bucket.srv_nginx_s3bucket.id
  acl    = "private"
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.srv_nginx_s3bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.cloudfront_origin_ai.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = aws_s3_bucket.srv_nginx_s3bucket.id
  policy = data.aws_iam_policy_document.s3_policy.json
}
