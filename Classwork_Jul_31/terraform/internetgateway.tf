
resource "aws_internet_gateway" "srv_nginx_igateway" {
  vpc_id = aws_vpc.srv_nginx_vpc.id

  tags = {
    Name = "nginx server internet gateway",
    PROJECT = var.project_name
  }
}