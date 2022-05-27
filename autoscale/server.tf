resource "sakuracloud_server" "server01" {
  count            = var.server01["count"]
  name             = format("%s-%s-%03d", module.label.id, var.server01["name"], count.index + 1)
  disks            = [element(sakuracloud_disk.disk01.*.id, count.index)]
  core             = var.server01["core"]
  memory           = var.server01["memory"]
  commitment       = var.server01["commitment"]
  interface_driver = var.server01["interface_driver"]

  network_interface {
    packet_filter_id = sakuracloud_packet_filter.filter01[0].id
    upstream         = sakuracloud_internet.router01[0].switch_id
  }

  network_interface {
    upstream = sakuracloud_switch.switch01[0].id
  }

  disk_edit_parameter {
    ip_address      = sakuracloud_internet.router01[0].ip_addresses[count.index + 3]
    gateway         = sakuracloud_internet.router01[0].gateway
    netmask         = var.router01["nw_mask_len"]
    hostname        = format("%s-%03d", var.server01["name"], count.index + 1)
    ssh_key_ids     = [sakuracloud_ssh_key_gen.sshkey01.id]
    password        = var.def_pass
    disable_pw_auth = var.server01["disable_pw_auth"]
    note {
      id = sakuracloud_note.script01.id
      variables = {
        eth1_ip = format("%s/%s", cidrhost(var.switch01["name"], 65 - var.server01["count"] + count.index), element(regex("^\\d+.\\d+.\\d+.\\d+/(\\d+)", var.switch01["name"]), 0))
      }
    }
  }

  description = format("%s%03d", var.server01["memo"], count.index + 1)
  tags        = concat(var.server_add_tag, module.label.attributes, [var.group_add_tag[count.index % length(var.group_add_tag)]])
}

resource "sakuracloud_server" "server02" {
  count            = var.server02["count"]
  name             = format("%s-%s-%03d", module.label.id, var.server02["name"], count.index + 1)
  disks            = [element(sakuracloud_disk.disk02.*.id, count.index)]
  core             = var.server02["core"]
  memory           = var.server02["memory"]
  commitment       = var.server02["commitment"]
  interface_driver = var.server02["interface_driver"]

  network_interface {
    upstream = sakuracloud_switch.switch01[0].id
  }

  disk_edit_parameter {
    ip_address      = cidrhost(var.switch01["name"], 33 - var.server02["count"] + count.index)
    gateway         = cidrhost(var.switch01["name"], 254)
    netmask         = tostring(element(regex("^\\d+.\\d+.\\d+.\\d+/(\\d+)", var.switch01["name"]), 0))
    hostname        = format("%s-%03d", var.server02["name"], count.index + 1)
    ssh_key_ids     = [sakuracloud_ssh_key_gen.sshkey01.id]
    password        = var.def_pass
    disable_pw_auth = var.server02["disable_pw_auth"]
    note {
      id = sakuracloud_note.script02.id
      variables = {
        loopback_ip = cidrhost(var.switch01["name"], var.lb01["vip1"])
      }
    }
  }

  description = format("%s%03d", var.server02["memo"], count.index + 1)
  tags        = concat(var.server_add_tag, module.label.attributes, [var.group_add_tag[count.index % length(var.group_add_tag)]])
}
