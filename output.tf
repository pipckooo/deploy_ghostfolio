output "ec2_public_ip" {
  value       = module.ec2.eip_public_ip
  description = "The public IP of the EC2 instance"
}
