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

# Define variables inline (you can move these to variables.tf if desired)
variable "ingress_port" {
  type    = list(number)
  default = [22]
}

variable "egress_port" {
  type    = list(number)
  default = [80, 443]
}

variable "internet_IP" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  dynamic "ingress" {
    for_each = var.ingress_port
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = var.internet_IP
    }
  }

  dynamic "egress" {
    for_each = var.egress_port
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = var.internet_IP
    }
  }
}

resource "aws_instance" "EC2" {
  ami           = "ami-05b8c5705ba972d30" # Amazon Linux 2 in ap-northeast-1
  instance_type = "t2.micro"
  key_name      = "tokyo"  # <-- replace this with your actual EC2 key pair name
  vpc_security_group_ids = [aws_security_group.ssh.id]

  provisioner "file" {
    source      = "1to100"
    destination = "/var/copy-file"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("tokyo")  # <-- replace with correct private key path
      host        = self.public_ip
    }
  }

  tags = {
    Name = "MyTerraformVM"
  }
}
