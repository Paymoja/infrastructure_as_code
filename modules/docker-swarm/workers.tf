resource "linode_instance" "docker_swarm_workers" {
    count = var.workers_count
    image = var.packer_image
    type = var.linodes_type
    group = local.instance_group
    label = "${local.instance_group}_${var.instance_label}_worker_${count.index + 1}"
    region = var.region
    authorized_keys = var.authorized_keys
    root_pass = var.root_password
    tags = var.tags
    swap_size = 1024
    private_ip = true
    connection {
    type        = "ssh"
    user        = var.root_username
    password    = var.root_password
    agent       = false
    host        = this.ip_address
  }
}

resource "null_resource" "init_workers"{
  depends_on = [
    null_resource.init_swarm_leader
  ]
  count = var.workers_count
  connection {
    type        = "ssh"
    user        = var.root_username
    password    = var.root_password
    agent       = false
    host        = linode_instance.docker_swarm_workers[count.index].ip_address
  }
  provisioner "remote-exec" {
    inline = [ 
    "export LINODE_CLI_TOKEN=${var.token}",
    "export LINODE_CLI_OBJ_ACCESS_KEY=${var.access_key}",
    "export LINODE_CLI_OBJ_SECRET_KEY=${var.secret_key}",
    "linode-cli obj --cluster ${var.bucket_location} ls",
    "linode-cli obj --cluster ${var.bucket_location} get docker-swarm-bucket-${var.environment_name} join-swarm-as-worker",
    "chmod +x join-swarm-as-worker",
    "./join-swarm-as-worker"
    ]
  }
}
