
resource "aws_route_table_association" "eks_rt_association" {
  subnet_id      = aws_subnet.eks_subnet.id
  route_table_id = aws_route_table.eks_route_table.id
}
