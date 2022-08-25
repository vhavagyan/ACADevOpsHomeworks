resource "aws_lb" "eks_lb" {
  internal           = false
  load_balancer_type = "network"
  security_groups    = [aws_security_group.eks_sec_group.id]
  subnets            = [aws_subnet.eks_subnet.id]

  tags = {
     Name = "load balancer behind cloudfront",
     PROJECT = var.project_name
  }
}

resource "aws_lb_listener" "eks_lb_listener" {
  load_balancer_arn = aws_lb.eks_lb.arn
  port              = "443"
  protocol          = "TLS"
  certificate_arn   = aws_acm_certificate.cert_for_cloudfront.arn
  alpn_policy       = "HTTP2Preferred"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.eks_lb_tg.arn
  }

  tags = {
     Name = "load balancer listener",
     PROJECT = var.project_name
  }
}

resource "aws_lb_target_group" "eks_lb_tg" {
  name     = "eks-lb-tg"
  port     = 443
  protocol = "TLS"
  vpc_id   = aws_vpc.eks_vpc.id

  tags = {
     Name = "load balancer target gorup",
     PROJECT = var.project_name
  }
}
