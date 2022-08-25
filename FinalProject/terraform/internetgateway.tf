
resource "aws_internet_gateway" "srv_ops_igateway" {
  vpc_id = aws_vpc.srv_ops_vpc.id

  tags = {
    Name = "OPS server internet gateway",
    PROJECT = var.project_name
  }
}


resource "aws_internet_gateway" "eks_igateway" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    Name = "EKS internet gateway",
    PROJECT = var.project_name
  }
}
