output "ec2_public_ip" {
  value = "${aws_instance.srv_nginx.public_ip}"
}