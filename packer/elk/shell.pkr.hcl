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
  image_description = "Development ELK instance"
  image_label       = "private-image-${local.timestamp}"
  instance_label    = "temporary-linode-${local.timestamp}"
  instance_type     = "g6-nanode-1"
  linode_token      = "87c4f58417db64bc0ec493eaf1d33072fcb54d41161cbecc7482b36f25bd8f1b"
  region            = "us-east"
  ssh_username      = "root"
}


build {
  sources = ["source.linode.elk"]
  provisioner "shell" {
  inline = [
    "sudo apt update",
    "sudo apt install -y openjdk-11-jre",
    "wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -",
    "sudo apt install --yes apt-transport-https",
    "echo \'deb https://artifacts.elastic.co/packages/7.x/apt stable main\' | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list",
    "echo \'deb https://artifacts.elastic.co/packages/oss-7.x/apt stable main\' | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list",
    "sudo apt-get install --yes elasticsearch",
    "sudo service elasticsearch start",
    "curl -X GET http://localhost:9200",
    "sudo apt install kibana",
    "sudo systemctl enable kibana",
    "sudo systemctl start kibana",
    "echo "kibanaadmin:'openssl passwd -apr1' | sudo tee -a /etc/nginx/htpasswd.users"
  ]
}


}




# source "null" "basic-example" {
#   ssh_host = "127.0.0.1"
#   ssh_username = "foo"
#   ssh_password = "bar"
# }

# build {
#   sources = ["sources.null.basic-example"]
# }





