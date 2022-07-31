resource "aws_vpc" "srv_nginx_vpc" {
  cidr_block = "10.10.0.0/16"

  tags = {
    Name = "nginx server vpc",
    PROJECT = var.project_name
  }
}
