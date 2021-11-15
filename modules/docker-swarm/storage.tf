data "linode_object_storage_cluster" "primary" {
  id = var.bucket_location
}

resource "linode_object_storage_bucket" "docker_swarm_bucket" {
  cluster = data.linode_object_storage_cluster.primary.id
  label = "docker-swarm-bucket-${var.environment_name}"
  access_key = var.access_key
  secret_key = var.secret_key  
}

