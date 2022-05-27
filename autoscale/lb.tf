resource "sakuracloud_load_balancer" "lb01" {
  network_interface {
    switch_id    = sakuracloud_switch.switch01[0].id
    vrid         = var.lb01["vrid"]
    ip_addresses = [cidrhost(var.switch01["name"], var.lb01["start_ip1"]), cidrhost(var.switch01["name"], var.lb01["start_ip2"])]
    gateway      = cidrhost(var.switch01["name"], var.vpc_router01["start_ip1"])
    netmask      = tostring(element(regex("^\\d+.\\d+.\\d+.\\d+/(\\d+)", var.switch01["name"]), 0))
  }

  plan        = var.lb01["plan"]
  name        = format("%s-%s", module.label.id, var.lb01["name"])
  description = var.lb01["memo"]
  tags        = module.label.attributes

  vip {
    vip        = cidrhost(var.switch01["name"], var.lb01["vip1"])
    port       = 80
    delay_loop = 10

    dynamic "server" {
      for_each = sakuracloud_server.server02
      content {
        ip_address = cidrhost(var.switch01["name"], 33 - var.server02["count"] + server.key)
        protocol   = "http"
        path       = "/"
        status     = 200
      }
    }
  }
}

