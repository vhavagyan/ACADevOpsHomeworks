resource "aws_route_table" "srv_ops_route_table" {
  vpc_id = aws_vpc.srv_ops_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.srv_ops_igateway.id
  }

  tags = {
    Name = "OPS server route table",
    PROJECT = var.project_name
  }
}


resource "aws_route_table" "eks_route_table" {
  vpc_id = aws_vpc.eks_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks_igateway.id
  }

  tags = {
    Name = "EKS route table",
    PROJECT = var.project_name
  }
}
