variable pub_key_path {
  description = "Path to ssh public key used to create this key on AWS"
}

variable ssh_user {
  description = "User used to log in to instance"
  default     = "ubuntu"
}

variable private_key_path {
  description = "Path to the private key used to connect to instance"
}

variable region {
  description = "Region"
  default     = "us-east-1"
}

variable aws_access_key {
  description = "Access Key"
}

variable aws_secret_key {
  description = "Secret Key"
}

variable env {
  description = "Environment prefix"
  default = "dev"
}

variable web_server_params {
  default = {
    "name"  = "web"
    "count" = "1"
  }
}

variable key_name {
  description = "name of ssh key to create"
}
