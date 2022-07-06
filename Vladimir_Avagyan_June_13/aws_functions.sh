#!/bin/bash

#script to provide aws CLI functionality

#====

#variable to store all created resources IDs
declare -agx awc_CreatedResourcesIDsArray
declare -agx awc_CreatedResourcesTypesArray

#==============================================================
#===resources create functions


#function gets tag JSON
function awc_GenerateResourceTags {
	#params
	declare p_resourcetype=$1
	declare p_projectname=$2
	declare p_expireinseconds=$3

	declare tagstring
	declare v_curtimestamp
	declare v_expireon
	declare var_tagjson

	tagstring='ResourceType=%s,Tags=[{Key=Name,Value=%s},{Key=PROJECT,Value=%s},{Key=EXPIREON,Value=%s}]'

	v_curtimestamp=$(date +%s)

	if [[ $p_expireinseconds -eq "0" || $p_expireinseconds -eq "-1" ]]
	then
		v_expireon=$p_expireinseconds
	else
		v_expireon=$(( $v_curtimestamp + $p_expireinseconds ))
	fi
	
	var_tagjson=$(printf "$tagstring" "$p_resourcetype" "$p_resourcetype-$p_projectname-$v_curtimestamp" "$p_projectname" "$v_expireon")

	echo $var_tagjson
}


#function to create VPC
function awc_CreateVPC {
	#params
	declare p_awsprofilename=$1
	declare p_vpccidr=$2
	declare p_resourcetags=$3
	#return params
	declare -n ret_vpcid=$4

	declare errcode
	declare s_output
	declare s_vpcid

	ret_vpcid=""

	s_output=$(aws --profile $p_awsprofilename \
				ec2 create-vpc \
   					--cidr-block $p_vpccidr \
   					--tag-specification $p_resourcetags \
					--query Vpc.VpcId --output text)

	errcode=$?
	if [[ ! $errcode == 0 ]]
	then
		return $errcode
	else
		s_vpcid=$s_output
		awc_StoreResToArray $s_vpcid "vpc"
		ret_vpcid=$s_vpcid
	fi
}


#function to create subnet in a VPC
function awc_CreateSubnet {
	#params
	declare p_awsprofilename=$1
	declare p_subnetcidr=$2
	declare p_vpcid=$3
	declare p_resourcetags=$4
	#return params
	declare -n ret_subnetid=$5

	declare errcode
	declare s_output
	declare s_subnetid

	s_output=$(aws --profile $p_awsprofilename \
				ec2 create-subnet \
   					--cidr-block $p_subnetcidr \
					--vpc-id $p_vpcid \
   					--tag-specification $p_resourcetags \
					--query Subnet.SubnetId --output text)

	errcode=$?
	if [[ ! $errcode == 0 ]]
	then
		return $errcode
	else
		s_subnetid=$s_output
		awc_StoreResToArray $s_subnetid "subnet"
		ret_subnetid=$s_subnetid
	fi
}


#function to create internet gateway and attach it to a VPC
function awc_CreateAttachInternetGateway {
	#params
	declare p_awsprofilename=$1
	declare p_vpcid=$2
	declare p_resourcetags=$3
	#return params
	declare -n ret_igwid=$4

	declare errcode
	declare s_output
	declare s_igwid

	s_output=$(aws --profile $p_awsprofilename \
				ec2 create-internet-gateway \
   					--tag-specification $p_resourcetags \
					--query InternetGateway.InternetGatewayId --output text)

	errcode=$?
	if [[ ! $errcode == 0 ]]
	then
		return $errcode
	else
		s_igwid=$s_output
		awc_StoreResToArray $s_igwid "internetgateway"
		ret_igwid=$s_igwid
	fi
	
	
	aws --profile $p_awsprofilename \
		ec2 attach-internet-gateway \
   			--internet-gateway-id $s_igwid \
			--vpc-id $p_vpcid
	
	errcode=$?
	if [[ ! $errcode == 0 ]]
	then
		return $errcode
	fi
}


#function to create route table and associate it to a VPC subnet
function awc_CreateAssociateRouteTable {
	#params
	declare p_awsprofilename=$1
	declare p_vpcid=$2
	declare p_subnetid=$3
	declare p_igwid=$4
	declare p_resourcetags=$5
	#return params
	declare -n ret_rtbid=$6

	declare errcode
	declare s_output
	declare s_rtbid

	s_output=$(aws --profile $p_awsprofilename \
				ec2 create-route-table \
					--vpc-id $p_vpcid \
					--tag-specification $p_resourcetags \
					--query RouteTable.RouteTableId --output text)

	errcode=$?
	if [[ ! $errcode == 0 ]]
	then
		return $errcode
	else
		s_rtbid=$s_output
		awc_StoreResToArray $s_rtbid "routetable"
		ret_rtbid=$s_rtbid
	fi
	

	s_output=$(aws --profile $p_awsprofilename \
				ec2 associate-route-table \
					--route-table-id $s_rtbid \
					--subnet-id $p_subnetid )
	
	errcode=$?
	if [[ ! $errcode == 0 ]]
	then
		return $errcode
	fi


	s_output=$(aws --profile $p_awsprofilename \
				ec2 create-route \
					--route-table-id $s_rtbid \
					--gateway-id $p_igwid \
					--destination-cidr-block 0.0.0.0/0 \
					--query Return --output text)
	
	errcode=$?
	if [[ ! $errcode == 0 ]]
	then
		return $errcode
	elif [ ${s_output,,} != "true" ]
	then
		echo "error on create-route"
		return 1
	fi

}


#==============================================================
#===resources cleanup functions


#function to store resource type and ID
function awc_StoreResToArray {
	awc_CreatedResourcesIDsArray+=($1)
	awc_CreatedResourcesTypesArray+=($2)
}


#function to remove created resources
function awc_CleanupResources {
	declare p_awsprofilename=$1

	declare errcode
	declare s_output
	declare v_resId
	declare v_resType
	declare s_vpcId

	#looping array in backward order
	indexes=( ${!awc_CreatedResourcesIDsArray[@]} )
	
	for ((i=${#indexes[@]} - 1; i >= 0; i--))
	do
    	v_resId=${awc_CreatedResourcesIDsArray[indexes[i]]}
        v_resType=${awc_CreatedResourcesTypesArray[indexes[i]]}

		#TODO: analyze resource type and delete resource
		if [ $v_resType = "vpc" ]
		then
			aws --profile $p_awsprofilename \
				ec2 delete-vpc \
					--vpc-id $v_resId
			
			errcode=$?
		elif [ $v_resType = "subnet" ]
		then
			aws --profile $p_awsprofilename \
				ec2 delete-subnet \
					--subnet-id $v_resId
			
			errcode=$?
		elif [ $v_resType = "internetgateway" ]
		then
			s_vpcId=$(aws --profile $p_awsprofilename \
						ec2 describe-internet-gateways \
							--internet-gateway-ids $v_resId \
							--query InternetGateways[0].Attachments[0].VpcId --output text)
			
			aws --profile $p_awsprofilename \
				ec2 detach-internet-gateway \
					--internet-gateway-id $v_resId \
					--vpc-id $s_vpcId

			aws --profile $p_awsprofilename \
				ec2 delete-internet-gateway \
					--internet-gateway-id $v_resId
			
			errcode=$?
		elif [ $v_resType = "routetable" ]
		then
			#TODO: disassociate route table
			aws --profile $p_awsprofilename \
				ec2 delete-route-table \
					--route-table-id $v_resId
			
			errcode=$?
		else
			echo "Unknown resource type to delete: $v_resType"
			return 1
		fi

		if [[ ! $errcode == 0 ]]
		then
			return $errcode
		fi
	done
}


#function to remove expired resources by EXPIREON tag
#tag value
#	0 - never expires
#	-1 - expires immediately
#	<timestamp> - expire date
function awc_DeleteExpiredResources {
	#TODO: get resources by tag EXPIREON and analyze 
	return 0	
}

