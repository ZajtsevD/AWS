#!/bin/bash

IMAGE_ID=ami-0b413adeb323658b1 #ami-034fffcc6a0063961
INSTANCE_TYPE=t2.micro
VPC_ID=vpc-0d177f4666b78d22f
KEY_NAME=user8
SECURITY_GROUP=sg-0a9362b86f955ff1a
SUBNET_ID=subnet-00be0f5b55838b5bf
SHUTDOWN_TYPE=stop
USER_NAME=user8
TAGS="ResourceType=instance,Tags=[{Key=installation_id,Value=${USER_NAME}-1},{Key=Name,Value=NAME}]"

start_vm()
{
  local private_ip_address="$1"
  local public_ip="$2"
  local name="$3"

  local tags=$(echo $TAGS | sed s/NAME/$name/)
# local tags-${TAGS/NAME/$name}

  aws ec2 run-instances \
    --image-id "$IMAGE_ID" \
    --instance-type "$INSTANCE_TYPE" \
    --key-name "$KEY_NAME" \
    --subnet-id "$SUBNET_ID" \
    --instance-initiated-shutdown-behavior "$SHUTDOWN_TYPE" \
    --private-ip-address "$private_ip_address" \
    --tag-specifications "$tags" \
    --${public_ip} \
#    [--block-device-mappings <value>]
#    [--placement <value>]
#    [--user-data <value>]
}

get_dns_name()
{  
  aws ec2 describe-instances --instance-ids ${instance} \
  | jq -r '.Reservations[0].Instances[0].NetworkInterfaces[0].Association.PublicDnsName'
}

start()
{
#  start_vm 10.4.1.81 associate-public-ip-address ${USER_NAME}-vm1
  for i in {2..3}; do
    start_vm 10.4.1.$((80+i)) no-associate-public-ip-address ${USER_NAME}-vm$i
  done
}

stop()
{
  ids=($(
    aws ec2 describe-instances \
    --query 'Reservations[*].Instances[?KeyName==`'$KEY_NAME'`].InstanceId' \
    --output text
  ))
  aws ec2 terminate-instances --instance-ids "${ids[@]}"
}

if [ "$1" = start ]; then
  start
elif [ "$1" = stop ]; then
  stop
else
  cat <<EOF
Usage:

  $0 start|stop
EOF
fi
