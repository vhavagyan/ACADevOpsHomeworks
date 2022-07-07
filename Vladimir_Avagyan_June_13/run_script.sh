#!/bin/bash

source ./default_values.sh
source ./aws_functions.sh


#===creating VPC
echo "$(date +'%F %T') Creating VPC..."

s_tag=$(awc_GenerateResourceTags "vpc" "$def_projecttag" "$def_expireinseconds")

declare var_vpcid
awc_CreateVPC $def_awspn $def_vpccidr $s_tag "var_vpcid"

errcode=$?
if [[ ! $errcode == 0 ]]
then
    echo "$(date +'%F %T') cleanup on vpc error"
    awc_CleanupResources $def_awspn
    exit $errcode
else
    echo "$(date +'%F %T') Create VPC succeeded"
fi


#===creating subnet
echo "$(date +'%F %T') Creating subnet..."

s_tag=$(awc_GenerateResourceTags "subnet" "$def_projecttag" "$def_expireinseconds")

declare var_subnetid
awc_CreateSubnet $def_awspn $def_subnetcidr $var_vpcid $s_tag "var_subnetid"

errcode=$?
if [[ ! $errcode == 0 ]]
then
    echo "$(date +'%F %T') cleanup on subnet error"
    awc_CleanupResources $def_awspn
    exit $errcode
else
    echo "$(date +'%F %T') Create subnet succeeded"
fi


#===creating internet gateway
echo "$(date +'%F %T') Creating and attaching internet gateway..."

s_tag=$(awc_GenerateResourceTags "internet-gateway" "$def_projecttag" "$def_expireinseconds")

declare var_igwid
awc_CreateAttachInternetGateway $def_awspn $var_vpcid $s_tag "var_igwid"

errcode=$?
if [[ ! $errcode == 0 ]]
then
    echo "$(date +'%F %T') cleanup on IGW error"
    awc_CleanupResources $def_awspn
    exit $errcode
else
    echo "$(date +'%F %T') Create internet gateway succeeded"
fi


#===creating route table
echo "$(date +'%F %T') Creating and associating route table..."

s_tag=$(awc_GenerateResourceTags "route-table" "$def_projecttag" "$def_expireinseconds")

declare var_routetableid
awc_CreateAssociateRouteTable $def_awspn $var_vpcid $var_subnetid $var_igwid $s_tag "var_routetableid"

errcode=$?
if [[ ! $errcode == 0 ]]
then
    echo "$(date +'%F %T') cleanup on Route Table error"
    awc_CleanupResources $def_awspn
    exit $errcode
else
    echo "$(date +'%F %T') Create route table succeeded"
fi


#===creating security group
echo "$(date +'%F %T') Creating security group..."

s_tag=$(awc_GenerateResourceTags "security-group" "$def_projecttag" "$def_expireinseconds")

declare var_securitygroupid
awc_CreateSecurityGroup $def_awspn $var_vpcid $s_tag "var_securitygroupid"

errcode=$?
if [[ ! $errcode == 0 ]]
then
    echo "$(date +'%F %T') cleanup on Security Group error"
    awc_CleanupResources $def_awspn
    exit $errcode
else
    echo "$(date +'%F %T') Create security group succeeded"
fi


#===

echo "$(date +'%F %T') DONE."

#TODO test cleanup
#awc_CleanupResources $def_awspn
