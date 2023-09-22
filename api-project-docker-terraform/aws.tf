# Create a security group to allow incoming SSH (port 22) and HTTP (port 80) traffic
resource "aws_security_group" "ec2_security_group" {
  name        = "ec2_security_group"
  description = "Security group for EC2 instance"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere (for development purposes)
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP from anywhere (for development purposes)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an EC2 instance
resource "aws_instance" "ec2_instance" {
  ami           = "ami-04cb4ca688797756f" # Specify an appropriate AMI ID
  instance_type = "t2.micro"              # Specify the instance type
  key_name      = "your_key_pair"               # Specify the key-pair pem file
  # Security group for the EC2 instance (allow SSH and HTTP)
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]
  tags = {
    Name = "Web Server of Bookstore"
  }
  # User data to execute when the instance starts
  user_data  = <<-EOF
          #!/bin/bash
          dnf update -y
          dnf install -y docker
          systemctl start docker
          systemctl enable docker
          usermod -a -G docker ec2-user
          newgrp docker
          curl -SL https://github.com/docker/compose/releases/download/v2.17.3/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
          chmod +x /usr/local/bin/docker-compose
          mkdir -p /home/ec2-user/bookstore-api
          TOKEN="your github token goes here"
          FOLDER="https://$TOKEN@raw.githubusercontent.com/Golge/bookstoreapi/main/"
          curl -s --create-dirs -o "/home/ec2-user/bookstore-api/bookstore-api.py" -L "$FOLDER"bookstore-api.py
          curl -s --create-dirs -o "/home/ec2-user/bookstore-api/requirements.txt" -L "$FOLDER"requirements.txt
          curl -s --create-dirs -o "/home/ec2-user/bookstore-api/Dockerfile" -L "$FOLDER"Dockerfile
          curl -s --create-dirs -o "/home/ec2-user/bookstore-api/docker-compose.yaml" -L "$FOLDER"docker-compose.yaml
          cd /home/ec2-user/bookstore-api
          docker build -t fatihgumush/bookstoreapi:latest .
          docker-compose up -d
  EOF
  depends_on = [github_repository.bookstoreapi, github_repository_file.app-files]
}

# Output the public IP address of the EC2 instance
output "public_ip" {
  value = aws_instance.ec2_instance.public_ip
}
