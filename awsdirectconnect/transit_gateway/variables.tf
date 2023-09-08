# environmental variables
variable "office_cidr" {}

# tag
variable "label" {
  default = {
    namespace = "saleseng"
    stage     = "dev"
    name      = "awsdirectconnect"
  }
}

# network
variable "vpc" {
  default = {
    cidr = "172.16.0.0/16"
  }
}

variable "vpc_cidr" {
  default = "172.16.0.0/16"
}

variable "sakura_cidr" {
  default = "192.168.0.0/24"
}

# ami
variable "instance_common" {
  default = {
    destribution = "ubuntu"
    version      = "bionic"
  }
}
