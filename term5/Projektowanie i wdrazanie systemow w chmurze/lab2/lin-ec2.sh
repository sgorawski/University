#!/usr/bin/env bash

# Create EC2 instance
# Print ID and public IP

KEY_NAME="clouds2018"
IMAGE_ID="ami-0681ed9bb7a58a33d"
DEFAULT_USERNAME="admin"
SECURITY_GROUP_ID="sg-0fb2c638c4de6f540"

INSTANCE_ID=$(
	aws ec2 run-instances \
	--image-id "$IMAGE_ID" \
	--security-group-ids "$SECURITY_GROUP_ID" \
	--count 1 \
	--instance-type t2.micro \
	--key-name "$KEY_NAME" \
	--query "Instances[0].InstanceId"
)

echo "Created instance with ID $INSTANCE_ID"

INSTANCE_PUB_IP=$(
	aws ec2 describe-instances \
	--instance-ids "$INSTANCE_ID" \
	--query "Reservations[0].Instances[0].PublicIpAddress"
)

echo "The instance's public IP is $INSTANCE_PUB_IP"
