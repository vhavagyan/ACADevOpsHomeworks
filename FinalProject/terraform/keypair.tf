resource "aws_key_pair" "srv_ops_keypair" {
  key_name = "OPS server key-pair"
  public_key = var.publicKeyMaterial
    
  tags = {
     Name = "OPS server key-pair",
     PROJECT = var.project_name
  }
}