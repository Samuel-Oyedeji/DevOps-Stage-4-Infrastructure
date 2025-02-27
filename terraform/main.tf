provider "aws" {
  region = "us-east-1"
}

# Define variables
variable "subnet_id" {
  description = "Subnet where the instance will be launched"
  type        = string
}

variable "security_group_id" {
  description = "Security Group for the instance"
  type        = string
}

variable "key_name" {
  description = "SSH Key Name"
  type        = string
}

variable "allowed_ssh_ip" {
  description = "Allowed SSH CIDR block (e.g., your public IP)"
  type        = string
  default     = "0.0.0.0/0" # Change this to a specific IP for security
}

resource "aws_instance" "app_server" {
  ami           = "ami-04b4f1a9cf54c11d0"
  instance_type = "t2.micro"
  subnet_id     = var.subnet_id
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.app_sg.id]

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

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_ip]  # Restrict SSH access
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
