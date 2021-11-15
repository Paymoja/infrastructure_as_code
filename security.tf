resource "linode_firewall" "docker-swarm-firewall" {
  label = "docker-swarm-firewall-${var.environment_name}"
  tags  = ["docker swarm, ${var.environment_name}, mbaza"]

  inbound {
    label    = "allow-ssh"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "22"
    ipv4     = ["0.0.0.0/0"]
    ipv6     = ["ff00::/8"]
  }

  inbound {
    label    = "allow-http"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "80,443"
    ipv4     = ["10.0.0.0/8", "192.0.0.0/8","172.0.0.0/8"]
  }

  # inbound {
  #   label    = "allow-https"
  #   action   = "ACCEPT"
  #   protocol = "TCP"
  #   ports    = "443"
  #   ipv4     = ["0.0.0.0/0"]
  #   ipv6     = ["ff00::/8"]
  # }

  inbound {
    label    = "allow-portainer"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "9000"
    ipv4     = ["0.0.0.0/0"]
    ipv6     = ["ff00::/8"]
  }

  inbound {
    label    = "allow-docker-swarm-tcp"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "2377,7946"
    ipv4     = ["192.168.0.0/16"]
  }
  inbound {
    label    = "allow-docker-swarm-udp"
    action   = "ACCEPT"
    protocol = "UDP"
    ports    = "4789,7946"
    ipv4     = ["192.168.0.0/16"]
  }

  inbound {
    label    = "allow-kba"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "3000"
    ipv4     = ["0.0.0.0/0"]
  }
  

  inbound {
    label    = "allow-rasa"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "5005"
    ipv4     = ["0.0.0.0/0"]
    ipv6     = ["ff00::/8"]
  }

  inbound_policy = "DROP"
  
  outbound_policy = "ACCEPT"
  
  linodes = module.mbaza_docker_swarm.nodes  
}
