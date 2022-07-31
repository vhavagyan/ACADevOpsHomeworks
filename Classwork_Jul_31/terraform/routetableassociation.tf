
resource "aws_route_table_association" "srv_nginx_rt_association" {
  subnet_id      = aws_subnet.srv_nginx_subnet.id
  route_table_id = aws_route_table.srv_nginx_route_table.id
}
