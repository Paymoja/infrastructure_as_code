resource "linode_firewall" "elastic-firewall" {
  label = "elastic-firewall-${var.environment_name}"
  tags  = ["elastic, kibana, dev, mbaza"]
  
  inbound {
    label    = "allow-ssh"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "22"
    ipv4     = ["0.0.0.0/0"]
    ipv6     = ["ff00::/8"]
  }

  inbound {
    label    = "allow-elastic"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "9200"
    ipv4     = ["0.0.0.0/0"]
    ipv6     = ["ff00::/8"]
  }

  inbound {
    label    = "allow-elastic"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "5601"
    ipv4     = ["0.0.0.0/0"]
    ipv6     = ["ff00::/8"]
  }

  inbound {
    label    = "allow-elastic-http"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "80"
    ipv4     = ["0.0.0.0/0"]
  }

  inbound_policy = "DROP"
  
  outbound_policy = "ACCEPT"
  
  linodes = [
      module.mbaza_elk_instance.node,

  ]
}
