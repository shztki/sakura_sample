resource "sakuracloud_server" "server01" {
  #zone  = var.default_zone
  count = var.server01["count"]
  #name             = format("%s-%03d", var.server01["name"], count.index + 1)
  name             = format("%s", var.server01["name"])
  disks            = [element(sakuracloud_disk.disk01.*.id, count.index)]
  core             = var.server01["core"]
  memory           = var.server01["memory"]
  commitment       = var.server01["commitment"]
  interface_driver = var.server01["interface_driver"]

  network_interface {
    packet_filter_id = sakuracloud_packet_filter.filter01.id
    upstream         = "shared"
  }

  disk_edit_parameter {
    hostname        = format("%s-%03d", var.server01["name"], count.index + 1)
    password        = var.default_password
    disable_pw_auth = var.server01["disable_pw_auth"]
    note {
      id = sakuracloud_note.script01.id
    }
  }

  description = format("%s-%03d", var.server01["memo"], count.index + 1)
  tags        = concat(module.label.attributes, [var.group_add_tag[count.index % length(var.group_add_tag)]])
  lifecycle {
    ignore_changes = [disk_edit_parameter]
  }
}

resource "sakuracloud_server" "server02" {
  #zone             = var.default_zone
  count            = var.server02["count"]
  name             = format("%s-%03d", var.server02["name"], count.index + 1)
  disks            = [element(sakuracloud_disk.disk02.*.id, count.index)]
  core             = var.server02["core"]
  memory           = var.server02["memory"]
  commitment       = var.server02["commitment"]
  interface_driver = var.server02["interface_driver"]

  network_interface {
    packet_filter_id = sakuracloud_packet_filter.filter01.id
    upstream         = "shared"
  }

  network_interface {
    upstream = sakuracloud_switch.switch01.id
  }

  disk_edit_parameter {
    hostname        = format("%s-%03d", var.server02["name"], count.index + 1)
    password        = var.default_password
    disable_pw_auth = var.server02["disable_pw_auth"]
    note {
      id = sakuracloud_note.script02.id
      variables = {
        eth1_ip = format("%s/%s", cidrhost(var.switch01["name"], var.server02["start_ip"] + count.index), element(regex("^\\d+.\\d+.\\d+.\\d+/(\\d+)", var.switch01["name"]), 0))
      }
    }
  }

  description = format("%s-%03d", var.server02["memo"], count.index + 1)
  tags        = concat(module.label.attributes, [var.group_add_tag[count.index % length(var.group_add_tag)]])
  lifecycle {
    ignore_changes = [disk_edit_parameter]
  }
}

resource "sakuracloud_server" "server03" {
  #zone             = var.default_zone
  count            = var.server03["count"]
  name             = format("%s-%03d", var.server03["name"], count.index + 1)
  disks            = [element(sakuracloud_disk.disk03.*.id, count.index)]
  core             = var.server03["core"]
  memory           = var.server03["memory"]
  commitment       = var.server03["commitment"]
  interface_driver = var.server03["interface_driver"]

  network_interface {
    packet_filter_id = sakuracloud_packet_filter.filter01.id
    upstream         = "shared"
  }

  network_interface {
    upstream = sakuracloud_switch.switch02.id
  }

  disk_edit_parameter {
    hostname        = format("%s-%03d", var.server03["name"], count.index + 1)
    password        = var.default_password
    disable_pw_auth = var.server03["disable_pw_auth"]
    note {
      id = sakuracloud_note.script02.id
      variables = {
        eth1_ip = format("%s/%s", cidrhost(var.switch02["name"], var.server03["start_ip"] + count.index), element(regex("^\\d+.\\d+.\\d+.\\d+/(\\d+)", var.switch02["name"]), 0))
      }
    }
  }

  description = format("%s-%03d", var.server03["memo"], count.index + 1)
  tags        = concat(module.label.attributes, [var.group_add_tag[count.index % length(var.group_add_tag)]])
  lifecycle {
    ignore_changes = [disk_edit_parameter]
  }
}
