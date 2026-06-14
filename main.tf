provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "main" {
  cidr_block       = "172.16.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "main"
  }
}

# Security Group
resource "aws_security_group" "jenkins_sg" {
  name        = var.security_group
  description = "security group for EC2 instance"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.security_group
  }
}

# EC2 Instance
resource "aws_instance" "my_first_instance" {
  ami                    = var.ami_id
  key_name               = var.key_name
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]

  tags = {
    Name = var.tag_name
  }
}

# Elastic IP (FIXED - removed deprecated "vpc")
resource "aws_eip" "my_first_eip" {
  domain = "vpc"

  instance = aws_instance.my_first_instance.id

  tags = {
    Name = "my_elastic_ip"
  }
}
