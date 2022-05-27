locals {
  port_forwarding_count = var.server02["count"] + 5
}

resource "sakuracloud_vpc_router" "vpc_router01" {
  count       = var.vpc_router01["count"]
  name        = format("%s-%s", module.label.id, var.vpc_router01["name"])
  description = var.vpc_router01["memo"]
  version     = var.vpc_router01["version"]
  tags        = module.label.attributes
  plan        = var.vpc_router01["plan"]

  internet_connection = var.vpc_router01["internet_connection"]

  public_network_interface {
    switch_id    = sakuracloud_internet.router01[0].switch_id
    vip          = sakuracloud_internet.router01[0].ip_addresses[0]
    ip_addresses = [sakuracloud_internet.router01[0].ip_addresses[1], sakuracloud_internet.router01[0].ip_addresses[2]]
    vrid         = var.vpc_router01["vrid"]
  }

  private_network_interface {
    index        = 1
    switch_id    = sakuracloud_switch.switch01[0].id
    vip          = cidrhost(var.switch01["name"], var.vpc_router01["start_ip1"])
    ip_addresses = [cidrhost(var.switch01["name"], var.vpc_router01["start_ip2"]), cidrhost(var.switch01["name"], var.vpc_router01["start_ip3"])]
    netmask      = tostring(element(regex("^\\d+.\\d+.\\d+.\\d+/(\\d+)", var.switch01["name"]), 0))
  }

  dynamic "port_forwarding" {
    for_each = range(33 - var.server02["count"], 33 + 5)
    content {
      protocol     = "tcp"
      public_port  = 22 + port_forwarding.key
      private_ip   = cidrhost(var.switch01["name"], 33 - var.server02["count"] + port_forwarding.key)
      private_port = 22
      description  = "desc"
    }
  }
  port_forwarding {
    protocol     = "tcp"
    public_port  = 80
    private_ip   = cidrhost(var.switch01["name"], var.lb01["vip1"])
    private_port = 80
    description  = "desc"
  }

  firewall {
    interface_index = 0

    direction = "receive"
    expression {
      protocol            = "ip"
      source_network      = var.office_cidr
      source_port         = ""
      destination_network = ""
      destination_port    = ""
      allow               = true
      logging             = true
      description         = "desc"
    }
    expression {
      protocol            = "tcp"
      source_network      = ""
      source_port         = ""
      destination_network = ""
      destination_port    = "80"
      allow               = true
      logging             = true
      description         = "desc"
    }
    expression {
      protocol            = "ip"
      source_network      = ""
      source_port         = ""
      destination_network = ""
      destination_port    = ""
      allow               = false
      logging             = true
      description         = "desc"
    }
  }
}
