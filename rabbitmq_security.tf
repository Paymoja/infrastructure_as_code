resource "linode_firewall" "rabbitmq-firewall" {
  label = "rabbitmq-firewall-${var.environment_name}"
  tags  = [" rabbitmq,${var.environment_name}, mbaza"]

 inbound {
    label    = "allow-ssh"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "22"
    ipv4     = ["0.0.0.0/0"]
    ipv6     = ["ff00::/8"]
  }
  inbound {
    label    = "allow-rabbitmq"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "5672"
    ipv4     = ["192.168.0.0/16"]
    ipv6     = ["ff00::/8"]
  }
  inbound {
    label    = "allow-rabbitmq"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "15672"
    ipv4     = ["0.0.0.0/0"]
    ipv6     = ["ff00::/8"]
  }

  inbound_policy = "DROP"

  outbound_policy = "ACCEPT"
  
  linodes = [
      module.mbaza_rabbitmq_instance.node

  ]
}
