# Configure AWS Provider
provider "aws" {
  region = "us-west-2"
}

# Create EC2 Instance
resource "aws_instance" "mongodb_server" {
  ami           = "ami-03f8acd418785369b" # Ubuntu 22.04
  instance_type = "t3.micro"
  key_name      = "oregon-key.pem"
  vpc_security_group_ids = [aws_security_group.mongodb_sg.id]

  tags = {
    Name = "MongoDB-Server"
  }
}

# Security Group
resource "aws_security_group" "mongodb_sg" {
  name = "mongodb-access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Output IP
output "instance_ip" {
  value = aws_instance.mongodb_server.public_ip
}
