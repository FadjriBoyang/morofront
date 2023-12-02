#! /bin/sh

yum update -y

amazon-linux-extras install docker
service docker start
usermod -a -G docker ec2-user
chkconfig docker on

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install



aws ecr get-login-password --region ap-southeast-1 | docker login --username AWS --password-stdin <AWS_ECR_ACCOUNT_URL>

docker pull <AWS_ECR_ACCOUNT_URL>/<AWS_RESOURCE_NAME_PREFIX>:latest


docker run -p 8080:8080 -d <AWS_ECR_ACCOUNT_URL>/<AWS_RESOURCE_NAME_PREFIX>