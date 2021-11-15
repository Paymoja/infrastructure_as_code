resource "null_resource" "setup_certificates" {
  provisioner "local-exec" {
    command = ".\\scripts\\setup-certificate.sh"

  }
}
resource "linode_nodebalancer" "mbaza_node_balancer" {
    label = "${var.environment_name}"
    region = "${var.region}"
    client_conn_throttle = 20
    tags = var.tags
}

resource "linode_nodebalancer_config" "http" {
    nodebalancer_id = linode_nodebalancer.mbaza_node_balancer.id
    port = 80
    protocol = "http"
    check = "http"
    check_path = "/"
    check_attempts = 3
    check_timeout = 5
    check_interval = 10
    stickiness = "none"
    algorithm = "roundrobin"
}

resource "linode_nodebalancer_config" "https" {
    depends_on = [
      null_resource.setup_certificates
    ]
    nodebalancer_id = linode_nodebalancer.mbaza_node_balancer.id
    port = 443
    protocol = "https"
    check = "http"
    check_path = "/"
    check_attempts = 3
    check_timeout = 5
    check_interval = 10
    stickiness = "none"
    algorithm = "roundrobin"
    ssl_cert = file("./certificates/fullchain.pem")
    ssl_key = file("./certificates/privkey.pem")
}

resource "linode_nodebalancer_node" "http_node" {
    count = length(module.mbaza_docker_swarm.instance_ip_address)
    nodebalancer_id = linode_nodebalancer.mbaza_node_balancer.id
    config_id = linode_nodebalancer_config.http.id
    address = "${element(module.mbaza_docker_swarm.instance_ip_address.*, count.index)}:80"
    label = "httpnode-${var.environment_name}"
    weight = 50
}

resource "linode_nodebalancer_node" "https_node" {
    count = length(module.mbaza_docker_swarm.instance_ip_address)
    nodebalancer_id = linode_nodebalancer.mbaza_node_balancer.id
    config_id = linode_nodebalancer_config.https.id
    address = "${element(module.mbaza_docker_swarm.instance_ip_address.*, count.index)}:80"
    label = "httpsnode-${var.environment_name}"
    weight = 50
}