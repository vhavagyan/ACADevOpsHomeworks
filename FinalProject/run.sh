#!/bin/bash

source ./variables.sh

#=====================================================


terraform -chdir=terraform apply -auto-approve

errcode=$?
if [[ $errcode != 0 ]]
then
	echo "error creating infrastructure"
	exit $errcode
fi


# get EC2 IP
ops_server_ip=$(terraform -chdir=terraform output -raw ec2_public_ip)


#get site DNS on cloudfront
cloudfront_dist_dn=$(terraform -chdir=terraform output -json cloudfront_dist_aliases)


# creating ansible cofig files
cat << EndOfMessage > ./ansible/hosts
[ops_server]
$ops_server_ip

[ops_server:vars]
ansible_ssh_user=ubuntu 
ansible_ssh_private_key_file=$ops_server_ssh_privatkey_file
EndOfMessage


# running ansible

# installing java and jenkins
ansible-playbook --ssh-extra-args "-o StrictHostKeyChecking=no" -i ansible/hosts ansible/java.yaml

errcode=$?
if [[ $errcode != 0 ]]
then
	echo "error on installing Java JRE"
	exit $errcode
fi


ansible-playbook --ssh-extra-args "-o StrictHostKeyChecking=no" -i ansible/hosts ansible/jenkins.yaml

errcode=$?
if [[ $errcode != 0 ]]
then
	echo "error on installing Jenkins"
	exit $errcode
fi


# installing prometheus server
ansible-playbook --ssh-extra-args "-o StrictHostKeyChecking=no" -i ansible/hosts ansible/prometheusserver.yaml

errcode=$?
if [[ $errcode != 0 ]]
then
	echo "error on installing Prometheus server"
	exit $errcode
fi


echo "=================================================="
echo "OPS server is ready $ops_server_ip"

echo "Website https://$cloudfront_dist_dn/"
