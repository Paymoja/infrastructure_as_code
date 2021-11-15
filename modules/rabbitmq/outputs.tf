output "instance_ip" {
  value = linode_instance.rabbitmq.ip_address
}

output "node" {
  value = linode_instance.rabbitmq.id    
}