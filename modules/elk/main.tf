
#server set up #
locals {
  instance_group = "${var.instance_group}_${var.environment_name}"
}
resource "linode_instance" "elk" {
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
    host        = linode_instance.elk.ip_address
  }

}



// ################################################################
// #
// # OUTPUT
// #
// ################################################################