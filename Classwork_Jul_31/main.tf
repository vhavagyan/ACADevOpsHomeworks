terraform {
  backend "s3" {
    bucket         = "terraform-backend-jul31"
    key            = "terraform.tfstate"
    region         = "us-east-1"
  }
}