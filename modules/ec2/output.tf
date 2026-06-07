output "instance_id" {
  value = aws_instance.server.id

}

output "instance_ip" {
  value = var.allocate_eip ? aws_eip.this[0].public_ip : aws_instance.server.public_ip
}

output "eip_public_ip" {
  value = var.allocate_eip ? aws_eip.this[0].public_ip : ""
}
