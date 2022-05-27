variable "default_zone" {
  default = "tk1b"
}

variable "zones" {
  default = ["tk1b"]
}

variable "def_pass" {}
variable "my_domain" {}
variable "office_cidr" {}

variable "label" {
  default = {
    namespace = "shztki"
    stage     = "dev"
    name      = "autoscale"
  }
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

variable "filter01" {
  default = {
    name = "filter01"
    memo = "example"
  }
}

variable "disk01" {
  default = {
    size      = 20       # min_linux:20
    plan      = "ssd"    # ssd or hdd
    connector = "virtio" # virtio or ide
    memo      = "example"
  }
}

variable "disk02" {
  default = {
    size      = 20
    plan      = "ssd"    # ssd or hdd
    connector = "virtio" # virtio or ide
    memo      = "example"
  }
}

variable "server01" {
  default = {
    os               = "alma8" # miracle8 / centos8(centos8stream) / centos7 / ubuntu18 / ubuntu20 / alma8 / rocky8
    count            = 1
    core             = 1
    memory           = 1
    commitment       = "standard" # "dedicatedcpu"
    interface_driver = "virtio"
    name             = "elb-base"
    memo             = "example"
    disable_pw_auth  = true
  }
}

variable "server02" {
  default = {
    os               = "alma8"
    count            = 1
    core             = 1
    memory           = 1
    commitment       = "standard"
    interface_driver = "virtio"
    name             = "lb-base"
    memo             = "example"
    disable_pw_auth  = true
  }
}

variable "switch01" {
  default = {
    count = 1
    name  = "192.168.201.0/24"
    memo  = "example"
  }
}

variable "script01" {
  default = {
    name  = "autoscale-centos-elb-init"
    class = "shell" # shell or yaml_cloud_config
    file  = "userdata/autoscale_centos_elb_init.sh"
  }
}

variable "script02" {
  default = {
    name  = "autoscale-centos-lb-init"
    class = "shell" # shell or yaml_cloud_config
    file  = "userdata/autoscale_centos_lb_init.sh"
  }
}

variable "router01" {
  default = {
    count       = 1
    name        = "router01"
    nw_mask_len = 28
    band_width  = 100
    enable_ipv6 = true
    memo        = "example"
  }
}

variable "vpc_router01" {
  default = {
    count               = 1
    name                = "vpcrouter01"
    memo                = "example"
    version             = 2
    plan                = "premium" # premium / standard
    vrid                = 200
    internet_connection = true
    vip1                = 254
    interface_ip1       = 253
    interface_ip2       = 252
  }
}

variable "lb01" {
  default = {
    name          = "lb"
    memo          = "example"
    plan          = "standard"
    vrid          = 100
    loopback_ip   = ""
    vip1          = 250
    interface_ip1 = 249
    interface_ip2 = 248
  }
}

variable "elb01" {
  default = {
    region         = "anycast" # is1 or tk1 or anycast
    name           = "elbtest001"
    memo           = "example"
    plan           = 1000
    vip_failover   = true # dns is true:fqdn or false:vip
    sticky_session = false
    gzip           = true
    timeout        = 10
  }
}

