
resource "aws_subnet" "eks_subnet" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = "10.10.10.0/24"

  tags = {
    Name = "EKS subnet",
    PROJECT = var.project_name
  }
}