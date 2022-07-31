
resource "aws_security_group" "srv_nginx_sec_group" {
  description = "Allow 80, 22 inbound, all outbound"
  vpc_id      = aws_vpc.srv_nginx_vpc.id

  ingress {
    description      = "nginx 80, All IPs"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "SSH, All IPs"
    from_port        = 22
    to_port          = 22
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
    Name = "allow_80_22",
    PROJECT = var.project_name
  }
}