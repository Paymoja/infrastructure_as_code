packer {
  required_plugins {
    linode = {
      version = ">= 0.0.1"
      source  = "github.com/hashicorp/linode"
    }
  }
}


locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

source "linode" "rabbitmq" {
  image             = "linode/ubuntu18.04"
  image_description = "Mbaza RabbitMQ Development instance"
  image_label       = "private-image-${local.timestamp}"
  instance_label    = "temporary-linode-${local.timestamp}"
  instance_type     = "g6-nanode-1"
  linode_token      = "87c4f58417db64bc0ec493eaf1d33072fcb54d41161cbecc7482b36f25bd8f1b"
  region            = "us-east"
  ssh_username      = "root"
}


build {
   sources = ["source.linode.rabbitmq"]

   provisioner "shell"{
        inline = [
          "sudo apt update",
          "sudo apt --yes install software-properties-common",
          "sudo apt --yes install erlang",
          "sudo apt-get --yes install python-psycopg2",
          "sudo apt-get --yes install -y python-apt",
          "sudo apt update && sudo apt install wget -y",
          "sudo apt install apt-transport-https -y",
          "sudo apt --yes install rabbitmq-server",
          "sudo systemctl enable rabbitmq-server",
          "sudo rabbitmq-plugins enable rabbitmq_management",
          "sudo ufw allow proto tcp from any to any port 5672,15672"
          ]


        expect_disconnect = true
    }

}






