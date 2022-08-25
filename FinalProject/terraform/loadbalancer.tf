resource "aws_lb" "eks_lb" {
  internal           = false
  load_balancer_type = "network"
  subnets            = [aws_subnet.eks_subnet.id]

  tags = {
     Name = "load balancer behind cloudfront",
     PROJECT = var.project_name
  }
}

resource "aws_lb_listener" "eks_lb_listener_80" {
  load_balancer_arn = aws_lb.eks_lb.arn
  port              = "80"
  protocol          = "TCP"
 
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.eks_lb_tg_80.arn
  }

  tags = {
     Name = "load balancer listener 80",
     PROJECT = var.project_name
  }
}

resource "aws_lb_listener" "eks_lb_listener_443" {
  load_balancer_arn = aws_lb.eks_lb.arn
  port              = "443"
  protocol          = "TLS"
  certificate_arn   = aws_acm_certificate.cert_for_cloudfront.arn
  alpn_policy       = "HTTP2Preferred"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.eks_lb_tg_443.arn
  }

  tags = {
     Name = "load balancer listener 443",
     PROJECT = var.project_name
  }
}

resource "aws_lb_target_group" "eks_lb_tg_80" {
  name     = "eks-lb-tg-80"
  port     = 80
  protocol = "TCP"
  target_type = "ip"
  vpc_id   = aws_vpc.eks_vpc.id

  tags = {
     Name = "load balancer target group 80",
     PROJECT = var.project_name
  }
}

resource "aws_lb_target_group" "eks_lb_tg_443" {
  name     = "eks-lb-tg-443"
  port     = 443
  protocol = "TLS"
  target_type = "ip"
  vpc_id   = aws_vpc.eks_vpc.id

  tags = {
     Name = "load balancer target group 443",
     PROJECT = var.project_name
  }
}

resource "aws_lb_target_group_attachment" "tg_attachment_80" {
  target_group_arn = aws_lb_target_group.eks_lb_tg_80.arn
  target_id        = "10.10.10.11"
  port             = 80
}

resource "aws_lb_target_group_attachment" "tg_attachment_443" {
  target_group_arn = aws_lb_target_group.eks_lb_tg_443.arn
  target_id        = "10.10.10.11"
  port             = 443
}
