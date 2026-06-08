terraform {
  required_version = "1.5.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.48.0"
    }
  }
}
resource "aws_instance" "server" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  user_data                   = var.user_data_script
  user_data_replace_on_change = true
  vpc_security_group_ids      = [aws_security_group.web_sg.id]

  tags = {
    Name = var.instance_name
  }
  key_name = var.key_name
}

resource "aws_eip" "this" {
  count  = var.allocate_eip ? 1 : 0
  domain = "vpc"

  tags = {
    Name = "${var.instance_name}-eip"
  }
}

resource "aws_eip_association" "this" {
  count         = var.allocate_eip ? 1 : 0
  instance_id   = aws_instance.server.id
  allocation_id = aws_eip.this[0].id
}

resource "aws_security_group" "web_sg" {
  name        = "${var.instance_name}-sg"
  description = "Security group for web server following least privilege"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
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
} 