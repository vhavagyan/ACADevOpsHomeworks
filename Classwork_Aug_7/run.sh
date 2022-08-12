#!/bin/bash

#default variables

#=====================================================


terraform -chdir=terraform apply -auto-approve

errcode=$?
if [[ $errcode != 0 ]]
then
	echo "error creating infrastructure"
	exit $errcode
fi


#get site DNS on cloudfront
cloudfront_dist_dn=$(terraform -chdir=terraform output -json cloudfront_dist_aliases)


echo "=================================================="
echo "Website is ready https://$cloudfront_dist_dn/"
