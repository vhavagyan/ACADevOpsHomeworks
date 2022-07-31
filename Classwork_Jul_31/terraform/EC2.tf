
resource "aws_instance" "srv_nginx" {
  ami           = var.nginxSrvImageId
  instance_type = var.nginxSrvType
  associate_public_ip_address = true
  subnet_id = aws_subnet.srv_nginx_subnet.id
  vpc_security_group_ids = [aws_security_group.srv_nginx_sec_group.id]

  key_name = aws_key_pair.srv_nginx_keypair.key_name

  tags = {
    Name = "nginx server",
    PROJECT = var.project_name
  }
}