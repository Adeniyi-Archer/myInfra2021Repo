# Security Group for SonarQube
resource "aws_security_group" "sonar_sg" {
  name        = "security_sonar_group_2022"
  description = "Security group for SonarQube"

  ingress {
    from_port   = 9000
    to_port     = 9000
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
    Name = "security_sonar"
  }
}

# Sonar EC2 Instance
resource "aws_instance" "my_sonar_instance" {
  ami                    = "ami-04680790a315cd58d"
  key_name               = var.key_name
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.sonar_sg.id]

  tags = {
    Name = "sonar_instance"
  }
}

# Elastic IP for Sonar (FIXED - removed deprecated vpc)
resource "aws_eip" "my_sonar_eip" {
  domain   = "vpc"
  instance = aws_instance.my_sonar_instance.id

  tags = {
    Name = "sonar_elastic_ip"
  }
}
