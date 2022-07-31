resource "aws_route_table" "srv_nginx_route_table" {
  vpc_id = aws_vpc.srv_nginx_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.srv_nginx_igateway.id
  }

  tags = {
    Name = "nginx server route table",
    PROJECT = var.project_name
  }
}
