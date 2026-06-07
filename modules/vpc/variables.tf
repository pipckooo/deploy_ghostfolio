variable "environment" {
    type = string
    description = "the deployment stage"
}

variable "vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
    description = "The primary IPV4 CIDR block for the entire VPC network "
}

variable "public_subnet_cidr" {
    type = string
    default = "10.0.1.0/24"
    description = "IP allocation range for the pub subnet tier"
}

variable "aws_region" {
    type = string
    default = "us-east-1"
    description = "The target aws region "
}