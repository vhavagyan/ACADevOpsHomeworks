
resource "aws_internet_gateway" "eks_igateway" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    Name = "EKS internet gateway",
    PROJECT = var.project_name
  }
}