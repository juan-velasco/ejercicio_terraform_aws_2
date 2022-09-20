output "private_ip" {
  value = aws_network_interface.nic-curso.private_ip
}

# output "public_ip" {
#   value = aws_eip.curso-aws.public_ip
# }