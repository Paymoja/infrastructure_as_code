resource "linode_firewall" "gitlab_agent_firewall" {
  label = "gitlab-agent-firewall-${var.environment_name}"
  tags  = [" gitlab-agent, ${var.environment_name}, mbaza"]

 inbound {
    label    = "allow-ssh"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "22"
    ipv4     = ["0.0.0.0/0"]
    ipv6     = ["ff00::/8"]
  }
  inbound_policy = "DROP"

  outbound_policy = "ACCEPT"
  
  linodes = module.mbaza_gitlab_agent_instance.node
  
}
