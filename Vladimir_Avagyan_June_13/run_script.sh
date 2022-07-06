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


#===creating internet gateway

s_tag=$(awc_GenerateResourceTags "internet-gateway" "$def_projecttag" "$def_expireinseconds")

declare var_igwid
awc_CreateAttachInternetGateway $def_awspn $var_vpcid $s_tag "var_igwid"

errcode=$?
if [[ ! $errcode == 0 ]]
then
    echo "cleanup on IGW error"
    awc_CleanupResources $def_awspn
    exit $errcode
fi


#===creating route table

s_tag=$(awc_GenerateResourceTags "route-table" "$def_projecttag" "$def_expireinseconds")

declare var_routetableid
awc_CreateAssociateRouteTable $def_awspn $var_vpcid $var_subnetid $var_igwid $s_tag "var_routetableid"

errcode=$?
if [[ ! $errcode == 0 ]]
then
    echo "cleanup on Route Table error"
    awc_CleanupResources $def_awspn
    exit $errcode
fi

#===
