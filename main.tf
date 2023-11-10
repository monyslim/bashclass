terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "entry_key_pair" {
  key_name   = "entry_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCnVAUVMrJa7LYrK5l/3wL97/IZ0GFX29su9/YGiuPeYGYegTuICQ6Yr2BB/4YP0SKAL4FZgWMalOLhKTVInDSzFxOEtwwCWkF+CF6j88oV9+Gi8jU3Paj9nx9Ib8nbLN5Osw7OelivTpVb9VyDrJKFDHQFO+LL1ddIcBf2b95icOjl43K+ZmaNhnSQNLoyiR+znH6csPGDl9gwZ2rxrBwCYrSfhdwL/QJCHSB2SP++nRRyuhtWoeqqSy/H3AiKWs5L1PeTwWO4DPr80mukSifX1LHPv6iyBKutf1+X2oO8ZfKxq0r1ark1/P9XagcEA7SRENUnmJxcp2++xry5tKhgwO1zeaUZwhnm8l4DH2+1CBUtMevaQziXhdeMNerVQIMB8V9u5JKaIjHmU0hUL7VTIwvVFjKIXp6a1yj7/Wnf4M9pEt4mr/XbzwE6EzvkFzAOLTgf5qaaE9hl8XPqKVolaa0tsPr6aZr3NAu4GE473q34M3CRzN/GWdBBd+Dbe2U= david@david-Latitude-E7470"
}

resource "aws_security_group" "create_entry_sg" {
  name        = "create_entry_sg"
  description = "This allows access to the instances"
  vpc_id      = "vpc-04d64f80071d1887e"

  ingress {
    description = "Allow SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Outbound traffic for demo1 instance"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "Security group for demo1 instance"
  }
}

resource "aws_instance" "demo1_instance" {
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  subnet_id     = "subnet-06e09c0e9342a167a"
  key_name      = aws_key_pair.entry_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.create_entry_sg.id]
  associate_public_ip_address = true
  user_data = file("/home/david/bashclass/work.sh")
  tags = {
    Name = "demo1_instance"
  }
  connection {
    host = self.public_ip
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("entry_key")}"
  }
  provisioner "file"{
    source = "rep.txt"
    destination ="/home/ubuntu/rep.txt"
    when = create
  }

}