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

# ami
variable "instance_common" {
  default = {
    destribution = "ubuntu"
    version      = "bionic"
  }
}
