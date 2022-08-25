
resource "aws_subnet" "srv_ops_subnet" {
  vpc_id            = aws_vpc.srv_ops_vpc.id
  cidr_block        = "10.10.1.0/24"

  tags = {
    Name = "ops server subnet",
    PROJECT = var.project_name
  }
}

resource "aws_subnet" "eks_subnet" {
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = "10.10.10.0/24"

  tags = {
    Name = "EKS subnet",
    PROJECT = var.project_name
  }
}