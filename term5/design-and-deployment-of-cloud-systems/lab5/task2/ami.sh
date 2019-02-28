#!/usr/bin/env bash

# Create instance, setup nginx and save as image
# Must configure region to eu-central-1
# and output format to text first

KEY_NAME="clouds2018"
KEY_FILE_PATH="../../clouds2018.pem"
IMAGE_ID="ami-0bdf93799014acdc4"
DEFAULT_USERNAME="ubuntu"
SECURITY_GROUP_ID="sg-0fb2c638c4de6f540"

INSTANCE_ID=$(
	aws ec2 run-instances \
	--image-id $IMAGE_ID \
	--security-group-ids $SECURITY_GROUP_ID \
	--count 1 \
	--instance-type t2.micro \
	--key-name $KEY_NAME \
	--query "Instances[0].InstanceId"
)

echo "Created instance with ID $INSTANCE_ID"

INSTANCE_PUB_IP=$(
	aws ec2 describe-instances \
	--instance-ids $INSTANCE_ID \
	--query "Reservations[0].Instances[0].PublicIpAddress"
)

echo "The instance's public IP is $INSTANCE_PUB_IP"

ssh \
-o StrictHostKeyChecking=no \
-o UserKnownHostsFile=/dev/null \
-i $KEY_FILE_PATH \
"$DEFAULT_USERNAME@$INSTANCE_PUB_IP" \
/bin/bash <<- CMDS
	sudo apt install -y nginx
	sudo touch /etc/nginx/sites-available/custom
	sudo chmod 666 /etc/nginx/sites-available/custom
	sudo cat > /etc/nginx/sites-available/custom << CFG
		server {
			listen 80;
			root /var/www/custom;
			index index.html;
		}
	CFG
	sudo ln -s /etc/nginx/sites-available/custom /etc/nginx/sites-enabled/custom
	sudo rm /etc/nginx/sites-enabled/default
	sudo mkdir /var/www/custom
	sudo touch /var/www/custom/index.html
	sudo chmod 666 /var/www/custom/index.html
	sudo cat > /var/www/custom/index.html << HTML
		<h1>Custom cfg</h1>
		<p>by sgorawski</p>
	HTML
	sudo service nginx restart
CMDS

echo "Set nginx up with custom default page, see $INSTANCE_PUB_IP"

IMAGE_ID=$(
	aws ec2 create-image \
	--instance-id $INSTANCE_ID \
	--name "clouds2018-lab1-task3-$INSTANCE_ID"
)

echo "Created image with ID $IMAGE_ID"
