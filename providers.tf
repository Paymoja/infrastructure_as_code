terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
    }
  }
}

provider "linode" {
  token = var.token
}

terraform {
  backend "s3" {
    bucket = "mbaza-tf-state"
    key    = "mbaza.digital"
    region = "eu-central-1"                       
    endpoint = "eu-central-1.linodeobjects.com"   
    skip_credentials_validation = true                
    access_key = "DOAV6P7692B64PLL8A80"
    secret_key = "qt5hUupKXeCv4KDjlhtqbNWuctfHj4tBjpmwwnja"
  }
}
