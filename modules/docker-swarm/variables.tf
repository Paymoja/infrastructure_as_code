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
    default = ["mbaza", "docker-swarm","master"]
}

variable managers_count {
  type = number
  default = 1
}

variable workers_count {
  type = number
  default = 0
}

variable instance_group{
  default ="mbaza"
}

variable "instance_label"{
  default = "swarm"
}

variable "token"{
  type = string
}

variable packer_image{}

variable "access_key"{
  default="DOAV6P7692B64PLL8A80"
}
variable "secret_key"{
  default="qt5hUupKXeCv4KDjlhtqbNWuctfHj4tBjpmwwnja"
}

variable "linodes_type" {
  default = "g6-standard-1"
}

variable "bucket_location" {
  default = "eu-central-1"
}
variable environment_name{}




