
resource "aws_subnet" "srv_nginx_subnet" {
  vpc_id            = aws_vpc.srv_nginx_vpc.id
  cidr_block        = "10.10.10.0/24"

  tags = {
    Name = "nginx server subnet",
    PROJECT = var.project_name
  }
}