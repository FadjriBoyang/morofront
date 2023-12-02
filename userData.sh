#! /bin/sh

yum update -y

amazon-linux-extras install docker
service docker start
usermod -a -G docker ec2-user
chkconfig docker on

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

AWS_ACCOUNT_ID=855044123636
AWS_REGION=ap-southeast-1
ECR_REPOSITORY_URL=public.ecr.aws/l8c4a5k9/morofront

aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REPOSITORY_URL

docker pull $ECR_REPOSITORY_URL:latest

docker run -p 8080:8080 -d "$ECR_REPOSITORY_URL:latest"