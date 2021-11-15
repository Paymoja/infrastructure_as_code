
locals {
  instance_group = "${var.instance_group}_${var.environment_name}"
}
resource "linode_instance" "rabbitmq" {
    #count = var.instance_count
    image = var.packer_image
    type = var.linodes_type
    group = local.instance_group
    label = "${local.instance_group}_${var.instance_label}"
    region = var.region
    authorized_keys = var.authorized_keys
    root_pass = var.root_password
    tags = var.tags
    swap_size = 256
    private_ip = true
    connection {
    type        = "ssh"
    user        = var.root_username
    password    = var.root_password
    agent       = false
    host        = linode_instance.rabbitmq.ip_address
  }
}

resource "null_resource" "rabbitmq_initial_configuration"{
  connection {
    type        = "ssh"
    user        = var.root_username
    password    = var.root_password
    agent       = false
    host        = linode_instance.rabbitmq.ip_address
  }
  provisioner "remote-exec"{
    inline = [
      "rabbitmqctl add_user ${var.rabbitmq_username} ${var.rabbitmq_password}",
      "rabbitmqctl set_user_tags admin administrator",
      "rabbitmqctl delete_user guest"
    ]
  }
}
