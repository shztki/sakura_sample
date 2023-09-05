resource "sakuracloud_local_router" "local_router01" {
  count       = var.localrouter01["count"]
  name        = format("%s-%s-%003d", module.label.id, var.localrouter01["name"], count.index + 1)
  description = var.localrouter01["memo"]
  tags        = module.label.attributes

  switch {
    code     = element(sakuracloud_switch.switch01.*.id, count.index)
    category = "cloud"
    zone_id  = var.default_zone
  }

  network_interface {
    vip          = cidrhost(var.switch01["name"], var.localrouter01["vip"])
    ip_addresses = [cidrhost(var.switch01["name"], var.localrouter01["interface_ip1"]), cidrhost(var.switch01["name"], var.localrouter01["interface_ip2"])]
    netmask      = tostring(element(regex("^\\d+.\\d+.\\d+.\\d+/(\\d+)", var.switch01["name"]), 0))
    vrid         = var.localrouter01["vrid"]
  }

  # after create awsdirectconnect
  #peer {
  #  peer_id     = var.aws_option_id
  #  secret_key  = var.aws_option_secret
  #  description = "description"
  #}
}

