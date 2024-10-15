#!/bin/bash
# Define the AWS region
PROFILE="default"
REGION="ap-south-1"    
NAME_FILTER="vpc"

# Retrieve instance information
INSTANCE_INFO=$(aws ec2 describe-instances \
--profile $PROFILE \
--region $REGION \
--query "Reservations[*].Instances[*].[InstanceId,Tags[?Key=='Name'].Value | [0], State.Name]" \
--output text | grep running | grep $NAME_FILTER)

if [ -n "$INSTANCE_INFO" ]; then
  INSTANCE_ID=$(echo $INSTANCE_INFO | awk '{print $1}')
  echo "Stopping instances: $NAME_FILTER with ID $INSTANCE_ID"
  aws ec2 stop-instances --instance-ids $INSTANCE_ID --profile $PROFILE --region $REGION
else
  echo "No instances found matching the name filter $NAME_FILTER."
fi
