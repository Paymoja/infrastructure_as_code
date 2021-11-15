output "instance_ip" {
  value = linode_instance.gitlab_agent.*.ip_address
}

output "node" {
  value = concat(linode_instance.gitlab_agent.*.id)
}