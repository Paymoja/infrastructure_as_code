packer {
  required_plugins {
    linode = {
      version = ">= 0.0.1"
      source  = "github.com/hashicorp/linode"
    }
  }
}


locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "linode" "elk" {
  image             = "linode/ubuntu18.04"
  image_description = "Mbaza ELK Development instance"
  image_label       = "private-image-${local.timestamp}"
  instance_label    = "temporary-linode-${local.timestamp}"
  instance_type     = "g6-nanode-1"
  linode_token      = "87c4f58417db64bc0ec493eaf1d33072fcb54d41161cbecc7482b36f25bd8f1b"
  region            = "us-east"
  ssh_username      = "root"
}

# source "null" "basic-example" {
#   ssh_host = "127.0.0.1"
#   ssh_username = "foo"
#   ssh_password = "bar"
# }

# build {
#   sources = ["sources.null.basic-example"]
# }



build {
   sources = ["source.linode.elk"]

   provisioner "shell"{
        inline = [
          "sudo apt update",
          "sudo apt --yes install software-properties-common",
          "sudo apt-get --yes install -y python-apt",
          "sudo apt-add-repository --update ppa:ansible/ansible",
          "sudo apt --yes install ansible"
          ]


        expect_disconnect = true
    }

   provisioner "ansible" {
      playbook_file = "./playbook/site.yml"
      ansible_env_vars =["ANSIBLE_ROLES_PATH=./playbook/roles"]
    }
}







