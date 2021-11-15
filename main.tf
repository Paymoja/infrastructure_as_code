module "mbaza_elk_instance" {
    source = "./modules/elk"
    instance_count = 1
    root_password = var.root_password
    packer_image = "private/13492191"
    token = var.token
    #linodes_type = "g6-standard-4"
    linodes_type = "g6-standard-1"
    tags = var.tags
    environment_name = var.environment_name
}

module "mbaza_postgres_instance" {
    source = "./modules/postgres"
    instance_count = 1
    root_password = var.root_password
    packer_image = "private/13485921"
    token = var.token
    #linodes_type = "g6-standard-2"
    linodes_type = "g6-standard-1"
    tags = var.tags
    environment_name = var.environment_name
}

module "mbaza_rabbitmq_instance" {
    source = "./modules/rabbitmq"
    instance_count = 1
    root_password = var.root_password
    packer_image = "private/13486246"
    token = var.token
    rabbitmq_username = var.rabbitmq_username
    rabbitmq_password = var.rabbitmq_password
    #linodes_type = "g6-standard-2"
    linodes_type = "g6-standard-1"
    tags = var.tags
    environment_name = var.environment_name
}

module "mbaza_docker_swarm" {
    source = "./modules/docker-swarm"
    managers_count = 2
    workers_count = 3
    root_password = var.root_password
    packer_image = "private/13848656"
    token = var.token
    tags = var.tags
    #linodes_type = "g6-standard-6"
    linodes_type = "g6-standard-1"
    environment_name = var.environment_name
}

module "mbaza_gitlab_agent_instance" {
    source = "./modules/gitlab-agent"
    root_password = var.root_password
    packer_image = "private/13848656"
    token = var.token
    #linodes_type = "g6-standard-4"
    linodes_type = "g6-standard-1"
    tags = var.tags
    environment_name = var.environment_name
}