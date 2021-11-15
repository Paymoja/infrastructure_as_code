variable "authorized_keys" {
  default = []
}


variable "root_password" {
  default = "9HZPtZs5w72YeMNv"
}


variable "root_username" {
  default = "root"
}


variable "region" {
  default = "eu-west"
}


variable "instance_label"{
  default = "rabbitmq"
}
variable tags {
    default = ["mbaza", "rabbitmq"]
}

variable "linodes_type" {
  default = "g6-standard-1"
}


variable instance_count {
  type = number
  default = 1
}


variable instance_group{
  default ="mbaza"
}

variable "token"{
  default ="87c4f58417db64bc0ec493eaf1d33072fcb54d41161cbecc7482b36f25bd8f1b"
}

variable packer_image{}

variable rabbitmq_username{}

variable rabbitmq_password{}

variable environment_name{}


