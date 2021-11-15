#server set up #
locals {
  instance_group = "${var.instance_group}_${var.environment_name}"
  gitlab_runner_tags = "linodes,${var.environment_name},docker,mbaza,rasa"
  gitlab_runner_description = "Mbaza-${var.environment_name}-docker-swarm"
  gitlab_runner_url ="https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64"
}
resource "linode_instance" "docker_swarm_managers" {
    count = var.managers_count
    image = var.packer_image
    type = var.linodes_type
    group = local.instance_group
    label = "${local.instance_group}_${var.instance_label}_manager_${count.index + 1}"
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

resource "null_resource" "delete_docker_swarm_bucket"{
  depends_on = [
    local_file.cleanup,
    linode_object_storage_bucket.docker_swarm_bucket
  ]
  provisioner "local-exec" {
    when = destroy
    command    = "${path.root}\\cleanup.sh"
    #on_failure = continue
  }
}

resource "null_resource" "init_swarm_leader"{
  
  connection {
    type        = "ssh"
    user        = var.root_username
    password    = var.root_password
    agent       = false
    host        = linode_instance.docker_swarm_managers[0].ip_address
  }

  provisioner "remote-exec" {
    inline = [ "docker swarm init --listen-addr ${linode_instance.docker_swarm_managers[0].private_ip_address} --advertise-addr ${linode_instance.docker_swarm_managers[0].private_ip_address}",
    "docker swarm join-token worker | tail -n 2 | grep docker > join-swarm-as-worker",
    "docker swarm join-token manager | tail -n 2 | grep docker> join-swarm-as-manager",
    "export LINODE_CLI_TOKEN=${var.token}",
    "export LINODE_CLI_OBJ_ACCESS_KEY=${linode_object_storage_bucket.docker_swarm_bucket.access_key}",
    "export LINODE_CLI_OBJ_SECRET_KEY=${linode_object_storage_bucket.docker_swarm_bucket.secret_key}",
    "linode-cli obj --cluster ${linode_object_storage_bucket.docker_swarm_bucket.cluster} ls",
    "linode-cli obj --cluster ${linode_object_storage_bucket.docker_swarm_bucket.cluster} put --acl-public join-swarm-as-worker docker-swarm-bucket-${var.environment_name}",
    "linode-cli obj --cluster ${linode_object_storage_bucket.docker_swarm_bucket.cluster} put --acl-public join-swarm-as-manager docker-swarm-bucket-${var.environment_name}",
    "docker service create -d -p 80:80 nginx"
    ]
  }
}

resource "local_file" "cleanup" {
  content = templatefile("${path.module}/cleanup.tpl", {token = var.token, environment_name = var.environment_name})
  filename = "cleanup.sh"
}

resource "null_resource" "init_managers"{
  depends_on = [
    null_resource.init_swarm_leader
  ]
  count = var.managers_count - 1
  connection {
    type        = "ssh"
    user        = var.root_username
    password    = var.root_password
    agent       = false
    host        = linode_instance.docker_swarm_managers[count.index + 1].ip_address
  }
  provisioner "remote-exec" {
    inline = [ 
    "export LINODE_CLI_TOKEN=${var.token}",
    "export LINODE_CLI_OBJ_ACCESS_KEY=${var.access_key}",
    "export LINODE_CLI_OBJ_SECRET_KEY=${var.secret_key}",
    "linode-cli obj --cluster ${var.bucket_location} ls",
    "linode-cli obj --cluster ${var.bucket_location} get docker-swarm-bucket-${var.environment_name} join-swarm-as-manager",
    "chmod +x join-swarm-as-manager",
    "./join-swarm-as-manager"
    ]
  
  }
}


resource "null_resource" "deploy_files"{
  connection {
    type        = "ssh"
    user        = var.root_username
    password    = var.root_password
    agent       = false
    host        = linode_instance.docker_swarm_managers[0].ip_address
  }

  provisioner "file" {
    source      = "./modules/docker-swarm/stacks/docker-compose.portainer.yaml"
    destination = "docker-compose.portainer.yaml"
  }

  provisioner "file" {
    source      = "./modules/docker-swarm/scripts/configure-dev-gitlab-runner-docker.sh"
    destination = "configure-dev-gitlab-runner-docker.sh"
  }

  provisioner "file" {
    source      = "./modules/docker-swarm/scripts/configure-dev-gitlab-runner-shell.sh"
    destination = "configure-dev-gitlab-runner-shell.sh"
  }

  provisioner "remote-exec" {
    inline = [
       "docker stack deploy -c docker-compose.portainer.yaml portainer",
       "docker ps"
    ]
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
