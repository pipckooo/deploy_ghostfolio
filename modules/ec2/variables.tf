variable "ami_id" {
  type        = string
  description = "The ami ID for the instance"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "subnet_id" {
  type        = string
  description = "the subnet to deploy into"
}

variable "instance_name" {
  type        = string
  description = "Name tag for EC2 instance"
}

variable "allocate_eip" {
  type        = bool
  default     = false
  description = "set true for allocation of Elastic IP"
}

variable "user_data_script" {
  type        = string
  description = "path to the user data script"
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC"
}

variable "my_ip" {
  type        = string
  description = "My IP address"
}