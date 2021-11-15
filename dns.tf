data "linode_domain" "mbaza_domain" {
    domain = "mbaza.digital"
    
}

resource "linode_domain_record" "main_subdomain" {
    domain_id = data.linode_domain.mbaza_domain.id
    name = var.environment_name
    record_type = "A"
    target = linode_nodebalancer.mbaza_node_balancer.ipv4
}

resource "linode_domain_record" "wildcard_subdomain" {
    domain_id = data.linode_domain.mbaza_domain.id
    name = "*.${var.environment_name}"
    record_type = "A"
    target = linode_nodebalancer.mbaza_node_balancer.ipv4
}

resource "linode_domain_record" "managers_subdomain" {
    count = length(module.mbaza_docker_swarm.managers_ip_address)
    domain_id = data.linode_domain.mbaza_domain.id
    name = "m${count.index+1}.${var.environment_name}"
    record_type = "A"
    target = module.mbaza_docker_swarm.managers_ip_address[count.index]
}

resource "linode_domain_record" "workers_subdomain" {
    count = length(module.mbaza_docker_swarm.workers_ip_address)
    domain_id = data.linode_domain.mbaza_domain.id
    name = "w${count.index+1}.${var.environment_name}"
    record_type = "A"
    target = module.mbaza_docker_swarm.workers_ip_address[count.index]
}

resource "linode_domain_record" "rabbitmq_subdomain" {
    domain_id = data.linode_domain.mbaza_domain.id
    name = "rabbitmq.${var.environment_name}"
    record_type = "A"
    target = module.mbaza_rabbitmq_instance.instance_ip
}

resource "linode_domain_record" "psotgres_subdomain" {
    domain_id = data.linode_domain.mbaza_domain.id
    name = "postgres.${var.environment_name}"
    record_type = "A"
    target = module.mbaza_postgres_instance.instance_ip
}

resource "linode_domain_record" "elastic_subdomain" {
    domain_id = data.linode_domain.mbaza_domain.id
    name = "elk.${var.environment_name}"
    record_type = "A"
    target = module.mbaza_elk_instance.instance_ip
}

resource "linode_domain_record" "gitlab_agent_subdomain" {
    count = length(module.mbaza_gitlab_agent_instance.instance_ip)
    domain_id = data.linode_domain.mbaza_domain.id
    name = "gitlab-agent.${var.environment_name}"
    record_type = "A"
    target = module.mbaza_gitlab_agent_instance.instance_ip[count.index]
}