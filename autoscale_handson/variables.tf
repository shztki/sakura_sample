variable "default_zone" {
  default = "is1b"
}

variable "zones" {
  default = ["is1a", "is1b", "tk1a", "tk1b"]
}

variable "default_password" {}
variable "api_key_id" {}

variable "label" {
  default = {
    namespace = "handson"
    stage     = "prd"
    name      = "autoscale"
  }
}

variable "group_add_tag" {
  default = ["@group=a", "@group=b", "@group=c", "@group=d"]
}

variable "filter01" {
  default = {
    name = "filter-001"
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

variable "disk03" {
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
    name             = "handson-work"
    memo             = "example"
    disable_pw_auth  = false
  }
}

variable "server02" {
  default = {
    os               = "alma8"
    count            = 2
    core             = 1
    memory           = 1
    commitment       = "standard"
    interface_driver = "virtio"
    name             = "scaleup-sv"
    memo             = "example"
    disable_pw_auth  = false
    start_ip         = 1
  }
}

variable "server03" {
  default = {
    os               = "alma8"
    count            = 2
    core             = 1
    memory           = 1
    commitment       = "standard"
    interface_driver = "virtio"
    name             = "scaleout-sv-base"
    memo             = "example"
    disable_pw_auth  = false
    start_ip         = 3
  }
}

variable "switch01" {
  default = {
    name = "192.168.0.0/24"
    memo = "scaleup-sw"
  }
}

variable "switch02" {
  default = {
    name = "192.168.0.0/24"
    memo = "scaleout-sw"
  }
}

variable "script01" {
  default = {
    name  = "autoscale-centos-work-init"
    class = "shell" # shell or yaml_cloud_config
    file  = "userdata/autoscale_centos_work_init.sh"
  }
}

variable "script02" {
  default = {
    name  = "autoscale-centos-elb-init"
    class = "shell" # shell or yaml_cloud_config
    file  = "userdata/autoscale_centos_elb_init.sh"
  }
}

variable "elb01" {
  default = {
    region         = "is1" # is1 or tk1 or anycast
    name           = "scaleup-elb"
    memo           = "example"
    plan           = 100
    vip_failover   = false # dns is true:fqdn or false:vip
    sticky_session = false
    gzip           = true
    timeout        = 10
  }
}

variable "elb02" {
  default = {
    region         = "is1" # is1 or tk1 or anycast
    name           = "scaleout-elb"
    memo           = "example"
    plan           = 100
    vip_failover   = false # dns is true:fqdn or false:vip
    sticky_session = false
    gzip           = true
    timeout        = 10
  }
}

variable "autoscale01" {
  default = {
    name     = "scaleup"
    cpu_up   = 60
    cpu_down = 40
    file     = "yaml/up.yaml"
    memo     = "example"
  }
}

variable "autoscale02" {
  default = {
    name     = "scaleout"
    cpu_up   = 50
    cpu_down = 20
    file     = "yaml/out.yaml"
    memo     = "example"
  }
}

