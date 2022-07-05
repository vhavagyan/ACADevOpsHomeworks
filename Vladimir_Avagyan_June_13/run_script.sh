#!/bin/bash

source ./default_values.sh
source ./aws_functions.sh


#===creating VPC

s_tag=$(awc_GenerateResourceTags "vpc" "$def_projecttag" "$def_expireinseconds")

declare s_vpcid
awc_CreateVPC $def_awspn $def_vpccidr $s_tag "s_vpcid"

errcode=$?
if [[ ! $errcode == 0 ]]
then
    echo "cleanup on vpc error" #TODO
    awc_CleanupResources
    exit $errcode
fi


#===creating subnet

s_tag=$(awc_GenerateResourceTags "subnet" "$def_projecttag" "$def_expireinseconds")

s_subnetid=$(awc_CreateSubnet $def_awspn $def_subnetcidr $s_vpcid $s_tag)

errcode=$?
if [[ ! $errcode == 0 ]]
then
    echo "cleanup on subnet error" #TODO
    awc_CleanupResources
    exit $errcode
fi


#===
