
resource "aws_security_group" "eks_sec_group" {
  description = "Allow 80, 443, all outbound"
  vpc_id      = aws_vpc.eks_vpc.id

  ingress {
    description      = "HTTP 80, All IPs"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "HTTPS, All IPs"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_80_443",
    PROJECT = var.project_name
  }
}