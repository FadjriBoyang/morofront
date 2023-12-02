terraform {
  required_providers {
   aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  required_version = "~> 1.0"
}

provider "aws" {
  profile = "default"
  region = "ap-southeast-1"

resource "aws_iam_role" "iam_role" {
    name = "ec2_boyang_role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Sid = ""
                Principal = {
                    Service = "ec2.amazonaws.com"
                }
            }
        ]
    })
}
resourse "aws_iam_instance_policy" "iam_policy {
    name = "ec2_boyang_iam-policy"
    role = aws_iam_role.iam_role.id
    
    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "ecr:*"
                Effect = "Allow"
                Resource = "*"
            },
        ]
    })
}

resource "aws_iam_instance_profile" "iam_instance_profile" {
    name = "ec2_boyang_profile"
    role = aws_iam_role.iam_role.name
}
resource "aws_security_group" "ec2_sg" {
    name = "sg"
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "app_server" {
    ami = "ami-02453f5468b897e31"
    instance_type = "t2.micro"
    user_data = file("../userData.sh")
    iam_instance_profile = aws_iam_instance_profile.iam_instance_profile.name
    vpc_security_group_ids = [aws_security_group.ec2_sg.id]

    tags = {
        Name = "EC2 Instance"
    }
}
}