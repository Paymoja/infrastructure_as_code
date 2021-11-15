variable "token" {}
variable "authorized_keys" {}
variable "root_pass" {}
variable "linode_region" {
  default = "us-southeast"
}


variable "rabbitmq_endpoint"{}
variable "rabbitmq_username"{}
variable "rabbitmq_password"{}

variable "postgres_port"{}



variable "environment_list"{
  type = list(string)
  default =["DEV", "STAGE", "PROD"]
}
variable "environment_map"{
  type = map(string)
  default = {
    "DEV"="DEV",
    "STAGE"="STAGE",
    "PROD"="PROD"
  }
}


variable "postgres_username"{}
variable "postgres_password"{}

variable "environment_name"{
  type = string
}

variable "tags"{
  type = list(string)
}

variable "region"{
  default = "eu-west"
}

variable "root_password"{
  type = string
}

variable "linodes_type" {

}
