output "instance_ip" {
  value = linode_instance.elk.ip_address
}

output "instance_public_ip_address" {
  value = linode_instance.elk.private_ip_address
}

output "node" {
  value = linode_instance.elk.id    
}


