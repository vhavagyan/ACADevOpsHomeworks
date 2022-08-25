resource "aws_vpc" "srv_ops_vpc" {
  cidr_block = "10.10.0.0/16"

  tags = {
    Name = "OPS server vpc",
    PROJECT = var.project_name
  }
}


resource "aws_vpc" "eks_vpc" {
  cidr_block = "10.10.0.0/16"

  tags = {
    Name = "EKS vpc",
    PROJECT = var.project_name
  }
}
