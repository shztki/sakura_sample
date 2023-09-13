# environmental variables
variable "office_cidr" {}
variable "default_password" {}
#var.aws_option_id {}
#var.aws_option_secret {}

variable "default_zone" {
  default = "is1b" # tk1b, is1b # tk1a, is1a
}

variable "zones" {
  default = ["is1b"] # tk1b, is1b, # tk1a, is1a
}

variable "label" {
  default = {
    namespace = "saleseng"
    stage     = "dev"
    name      = "awsdirectconnect"
  }
}

variable "aws_cidr" {
  default = "172.16.0.0/16"
}

variable "server_add_tag" {
  default = ["@auto-reboot"]
}

variable "group_add_tag" {
  default = ["@group=a", "@group=b", "@group=c", "@group=d"]
}

variable "sshkey01" {
  default = {
    name = "sshkey01"
    memo = "example"
  }
}

variable "disk02" {
  default = {
    name      = "db-disk"
    size      = 20    # min win:100 / linux:20
    plan      = "ssd" # ssd or hdd
    connector = "virtio"
    memo      = "example"
  }
}

variable "server02" {
  default = {
    os               = "rocky9" # miracle8/9, alma8/9, rocky8/9, ubuntu20/22
    count            = 1
    core             = 1
    memory           = 1
    commitment       = "standard" # "dedicatedcpu"
    interface_driver = "virtio"
    name             = "db"
    memo             = "example"
    disable_pw_auth  = true
    start_ip         = 50
  }
}

variable "init_script01" {
  default = {
    name  = "rhel_init"
    class = "shell" # shell or yaml_cloud_config
    file  = "userdata/rhel_init.sh"
  }
}

variable "init_script02" {
  default = {
    name  = "ubuntu_init"
    class = "shell" # shell or yaml_cloud_config
    file  = "userdata/ubuntu_init.sh"
  }
}

variable "switch01" {
  default = {
    name = "192.168.0.0/24"
    memo = "example"
  }
}

variable "vpc_router01" {
  default = {
    count               = 1
    name                = "vpc"
    memo                = "example"
    version             = 2
    plan                = "standard"
    internet_connection = true
    vip                 = 254
  }
}

variable "localrouter01" {
  default = {
    count         = 1
    name          = "localrouter"
    memo          = "example"
    vip           = 1
    interface_ip1 = 2
    interface_ip2 = 3
    vrid          = 255
  }
}

