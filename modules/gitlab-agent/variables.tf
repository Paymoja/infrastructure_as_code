variable "authorized_keys" {
  default = []
}

#do not define default for passwords
variable "root_password" {
}


variable "root_username" {
  default = "root"
}


variable "region" {
  default = "eu-west"
}

variable tags {
    default = ["mbaza", "gitlab-agent"]
}


variable instance_count {
  type = number
  default = 1
}


variable instance_group{
  default ="mbaza"
}

variable "instance_label"{
  default = "gitlab_agent"
}

variable "token"{
  default ="87c4f58417db64bc0ec493eaf1d33072fcb54d41161cbecc7482b36f25bd8f1b"
}

variable packer_image{}

variable environment_name{}

variable "gitlab_runner_tags" {
    default = "linodes,development,docker,mbaza,rasa,gitlab-agent"
}

variable "linodes_type" {
  default = "g6-standard-1"
}

