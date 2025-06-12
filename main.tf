terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.internet_IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.internet_IP
  }
}

resource "aws_instance" "EC2" {
  ami                    = "ami-05b8c5705ba972d30"
  instance_type          = "t2.micro"
  security_groups        = [aws_security_group.ssh.name]

  tags = {
    Name = "MyTerraformVM"
  }
}
