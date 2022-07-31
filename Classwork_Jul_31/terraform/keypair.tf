resource "aws_key_pair" "srv_nginx_keypair" {
  key_name = "nginx server key-pair"
  public_key = var.publicKeyMaterial
    
  tags = {
     Name = "nginx server key-pair",
     PROJECT = var.project_name
  }
}