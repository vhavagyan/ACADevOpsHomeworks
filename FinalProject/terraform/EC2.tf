
resource "aws_instance" "srv_ops" {
  ami           = var.OPSSrvImageId
  instance_type = var.OPSSrvType
  associate_public_ip_address = true
  subnet_id = aws_subnet.srv_ops_subnet.id
  vpc_security_group_ids = [aws_security_group.srv_ops_sec_group.id]

  key_name = aws_key_pair.srv_ops_keypair.key_name

  tags = {
    Name = "OPS server",
    PROJECT = var.project_name
  }
}