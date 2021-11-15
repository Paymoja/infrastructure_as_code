resource "linode_firewall" "postgres-firewall" {
  label = "postgres-firewall-${var.environment_name}"
  tags  = ["postgres, hashicorp,${var.environment_name}, mbaza"]

 inbound {
    label    = "allow-ssh"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "22"
    ipv4     = ["0.0.0.0/0"]
    ipv6     = ["ff00::/8"]
  }

  inbound {
    label    = "allow-postgres"
    action   = "ACCEPT"
    protocol = "TCP"
    ports    = "5432"
    ipv4     = ["0.0.0.0/0"]
    ipv6     = ["ff00::/8"]
  }

  inbound_policy = "DROP"

  outbound_policy = "ACCEPT"
  
  linodes = [
      module.mbaza_postgres_instance.node,

  ]
}
