provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "app_server" {
  ami           = "ami-04b4f1a9cf54c11d0"  # Amazon Linux / Ubuntu AMI
  instance_type = "t2.micro"
  key_name      = "your-ssh-key"           # Only for emergency access (Not used for Ansible)
  security_groups = [aws_security_group.app_sg.name]

  # User data runs our Ansible Pull script when the server starts
  user_data = file("${path.module}/provision.sh")

  tags = {
    Name = "DevOps-Stage-4-Server"
  }
}

resource "aws_security_group" "app_sg" {
  name        = "app_security_group"
  description = "Allow inbound traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTPS
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "server_public_ip" {
  value = aws_instance.app_server.public_ip
}
