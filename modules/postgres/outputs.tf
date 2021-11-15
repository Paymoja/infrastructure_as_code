output "instance_ip" {
  value = linode_instance.postgres.ip_address
}

output "node" {
  value = linode_instance.postgres.id    
}