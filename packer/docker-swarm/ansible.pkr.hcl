packer {
  required_plugins {
    linode = {
      version = ">= 0.0.1"
      source  = "github.com/hashicorp/linode"
    }
  }
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "linode" "docker-Swarm" {
  image             = "linode/ubuntu18.04"
  image_description = "Mbaza Docker Swarm Development instance"
  image_label       = "private-image-${local.timestamp}"
  instance_label    = "temporary-linode-${local.timestamp}"
  instance_type     = "g6-standard-6"
  linode_token      = "87c4f58417db64bc0ec493eaf1d33072fcb54d41161cbecc7482b36f25bd8f1b"
  region            = "us-east"
  ssh_username      = "root"
}

build {
   sources = ["source.linode.docker-Swarm"]
   provisioner "file"{
       source = "./scripts/install-gitlab-runner.sh"  
       destination = "/tmp/install-gitlab-runner.sh"
   }
   provisioner "shell"{
        inline = [
          "sudo apt update",
          "sudo apt --yes install software-properties-common",
          "sudo apt --yes install apt-transport-https ca-certificates curl gnupg lsb-release",
          "sudo apt-add-repository --update ppa:ansible/ansible",
          "sudo apt --yes install ansible",
          "ls /tmp/",
          "apt --yes install gitlab-runner",
          "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
          "sudo add-apt-repository 'deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable'",
          "sudo apt update",
          "apt-cache policy docker-ce",
          "sudo apt --yes install docker-ce",
          "sudo usermod -aG docker $USER",
          "sudo apt --yes install python3-pip",
          "pip3 install linode-cli --upgrade",
          "pip3 install boto"
          ]
        expect_disconnect = true
    }

}











