locals {
  #protocol         = ["tcp", "tcp", "tcp", "icmp", "tcp", "udp", "fragment", "ip"]
  #source_network   = ["", "", "", "", "", "", "", ""]
  #source_port      = ["", "", "", "", "", "", "", ""]
  #destination_port = ["22", "80", "443", "", "32768-61000", "32768-61000", "", ""] # for linux
  #allow            = [true, true, true, true, true, true, true, false]
  protocol         = ["tcp", "tcp", "udp", "fragment", "ip"]
  source_network   = ["", "", "", "", ""]
  source_port      = ["", "", "", "", ""]
  destination_port = ["80", "32768-61000", "32768-61000", "", ""] # for linux
  allow            = [true, true, true, true, false]
}

resource "sakuracloud_packet_filter" "filter01" {
  #zone        = var.default_zone
  name        = format("%s-%s", module.label.id, var.filter01["name"])
  description = var.filter01["memo"]

  dynamic "expression" {
    for_each = local.protocol
    content {
      protocol         = local.protocol[expression.key]
      source_network   = local.source_network[expression.key]
      source_port      = local.source_port[expression.key]
      destination_port = local.destination_port[expression.key]
      allow            = local.allow[expression.key]
    }
  }
}

#resource "sakuracloud_packet_filter" "filter02" {
#  #zone        = var.default_zone
#  name        = format("%s-%s", module.label.id, var.filter02["name"])
#  description = var.filter02["memo"]
#
#  dynamic "expression" {
#    for_each = sakuracloud_proxylb.elb01.proxy_networks
#    content {
#      protocol         = "tcp"
#      source_network   = expression.value
#      source_port      = ""
#      destination_port = 80
#      allow            = true
#    }
#  }
#
#  dynamic "expression" {
#    for_each = local.protocol
#    content {
#      protocol         = local.protocol[expression.key]
#      source_network   = local.source_network[expression.key]
#      source_port      = local.source_port[expression.key]
#      destination_port = local.destination_port[expression.key]
#      allow            = local.allow[expression.key]
#    }
#  }
#}
#
#resource "sakuracloud_packet_filter" "filter03" {
#  #zone        = var.default_zone
#  name        = format("%s-%s", module.label.id, var.filter03["name"])
#  description = var.filter03["memo"]
#
#  dynamic "expression" {
#    for_each = sakuracloud_proxylb.elb02.proxy_networks
#    content {
#      protocol         = "tcp"
#      source_network   = expression.value
#      source_port      = ""
#      destination_port = 80
#      allow            = true
#    }
#  }
#
#  dynamic "expression" {
#    for_each = local.protocol
#    content {
#      protocol         = local.protocol[expression.key]
#      source_network   = local.source_network[expression.key]
#      source_port      = local.source_port[expression.key]
#      destination_port = local.destination_port[expression.key]
#      allow            = local.allow[expression.key]
#    }
#  }
#}
#
