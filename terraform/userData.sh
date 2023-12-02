#!/bin/bash -eo pipefail

yum update -y

amazon-linux-extras install docker
service docker start
usermod -a -G docker ec2-user
chkconfig docker on

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Configure AWS CLI with the correct region
aws configure set aws_access_key_id <YOUR_ACCESS_KEY>
aws configure set aws_secret_access_key <YOUR_SECRET_KEY>
aws configure set region <AWS_REGION>

# Authenticate Docker with ECR
aws ecr get-login-password | docker login --username AWS --password-stdin <AWS_ECR_ACCOUNT_URL>

# Pull the Docker image
docker pull <AWS_ECR_ACCOUNT_URL>/<AWS_RESOURCE_NAME_PREFIX>:latest

# Run the Docker container
docker run -p 8080:8080 -d <AWS_ECR_ACCOUNT_URL>/<AWS_RESOURCE_NAME_PREFIX>
