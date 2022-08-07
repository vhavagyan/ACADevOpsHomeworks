#!/bin/bash

#default variables

nginx_server_ssh_privatkey_file="~/.ssh/EC2SSHAccess"

#=====================================================


terraform -chdir=terraform apply -auto-approve

errcode=$?
if [[ $errcode != 0 ]]
then
	echo "error creating infrastructure"
	exit $errcode
fi


# get EC2 IP
nginx_server_ip=$(terraform -chdir=terraform output -raw ec2_public_ip)

#get site DNS on cloudfront
cloudfront_dist_dn=$(terraform -chdir=terraform output -json cloudfront_dist_aliases)

# creating ansible cofig files
cat << EndOfMessage > ./ansible/hosts
[nginx_server]
$nginx_server_ip

[nginx_server:vars]
ansible_ssh_user=ubuntu 
ansible_ssh_private_key_file=$nginx_server_ssh_privatkey_file
EndOfMessage


# running ansible

ansible-playbook --ssh-extra-args "-o StrictHostKeyChecking=no" -i ansible/hosts ansible/nginx.yaml

errcode=$?
if [[ $errcode != 0 ]]
then
	echo "error on installing nginx"
	exit $errcode
fi


echo "=================================================="
echo "Website is ready http://$nginx_server_ip/"

echo "Try also https://$cloudfront_dist_dn/"
