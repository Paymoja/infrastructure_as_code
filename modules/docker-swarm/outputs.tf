output "instance_ip_address" {
  value = linode_instance.docker_swarm_managers.*.private_ip_address
}

output "managers_ip_address" {
  value = linode_instance.docker_swarm_managers.*.ip_address
}

output "workers_ip_address" {
  value = linode_instance.docker_swarm_workers.*.ip_address
}

output "nodes" {
  value = concat( linode_instance.docker_swarm_managers.*.id,
      linode_instance.docker_swarm_workers.*.id)
      
}