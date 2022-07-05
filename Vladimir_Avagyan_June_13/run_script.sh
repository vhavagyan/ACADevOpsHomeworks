#!/bin/bash

source ./default_values.sh
source ./aws_functions.sh


#===creating VPC

s_tag=$(awc_GenerateResourceTags "vpc" "$def_projecttag" "$def_expireinseconds")

declare var_vpcid
awc_CreateVPC $def_awspn $def_vpccidr $s_tag "var_vpcid"

errcode=$?
if [[ ! $errcode == 0 ]]
then
    echo "cleanup on vpc error"
    awc_CleanupResources $def_awspn
    exit $errcode
fi


#===creating subnet

s_tag=$(awc_GenerateResourceTags "subnet" "$def_projecttag" "$def_expireinseconds")

declare var_subnetid
awc_CreateSubnet $def_awspn $def_subnetcidr $var_vpcid $s_tag "var_subnetid"

errcode=$?
if [[ ! $errcode == 0 ]]
then
    echo "cleanup on subnet error"
    awc_CleanupResources $def_awspn
    exit $errcode
fi


#===
