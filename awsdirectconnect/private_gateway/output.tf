output "ssh_private_key" {
  value     = tls_private_key.this.private_key_pem
  sensitive = true
}

output "ec2_public_ip" {
  value = module.ec2.public_ip
}

output "ec2_private_ip" {
  value = module.ec2.private_ip
}

#output "ec2_private_private_ip" {
#  value = module.ec2_private.private_ip
#}
