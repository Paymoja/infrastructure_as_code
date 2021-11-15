locals {
  instance_group = "${var.instance_group}_${var.environment_name}"
  gitlab_runner_tags = "linodes,${var.environment_name},docker,gitlab-agent"
  gitlab_runner_description = "Mbaza-${var.environment_name}-gitlab-agent"
  gitlab_runner_url ="https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64"
}
resource "linode_instance" "gitlab_agent" {
    count = 1
    image = var.packer_image
    type = var.linodes_type
    group = local.instance_group
    label = "${local.instance_group}_${var.instance_label}"
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
    host        = self.ip_address
  }
  
}

resource "null_resource" "deploy_files"{
  connection {
    type        = "ssh"
    user        = var.root_username
    password    = var.root_password
    agent       = false
    host        = linode_instance.gitlab_agent[0].ip_address
  }

  provisioner "file" {
    source      = "./modules/gitlab-agent/scripts/install-gitlab-runner.sh"
    destination = "install-gitlab-runner.sh"
  }

  provisioner "file" {
    source      = "./modules/gitlab-agent/scripts/configure-dev-gitlab-runner-docker.sh"
    destination = "configure-dev-gitlab-runner-docker.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo curl -L --output /usr/local/bin/gitlab-runner ${local.gitlab_runner_url}",
      "chmod +x /usr/local/bin/gitlab-runner",
      "useradd --comment 'GitLab Runner' --create-home gitlab-runner --shell /bin/bash",
      "gitlab-runner install --user=gitlab-runner --working-directory=/home/gitlab-runner",
      "gitlab-runner start", 
      "chmod +x configure-dev-gitlab-runner-docker.sh",  
      "echo ${local.gitlab_runner_tags}",
      "./configure-dev-gitlab-runner-docker.sh ${local.gitlab_runner_description} ${local.gitlab_runner_tags}"
    ]
  }
}