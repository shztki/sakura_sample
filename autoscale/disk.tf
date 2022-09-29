resource "sakuracloud_disk" "disk01" {
  count             = var.server01["count"]
  name              = format("%s-%s-%03d", module.label.id, var.server01["name"], count.index + 1)
  source_archive_id = var.server01["os"] == "ubuntu18" ? data.sakuracloud_archive.ubuntu18[var.default_zone].id : var.server01["os"] == "ubuntu20" ? data.sakuracloud_archive.ubuntu20[var.default_zone].id : var.server01["os"] == "alma8" ? data.sakuracloud_archive.alma8[var.default_zone].id : var.server01["os"] == "rocky8" ? data.sakuracloud_archive.rocky8[var.default_zone].id : var.server01["os"] == "miracle8" ? data.sakuracloud_archive.miracle8[var.default_zone].id : data.sakuracloud_archive.centos7[var.default_zone].id
  plan              = var.disk01["plan"]
  connector         = var.disk01["connector"]
  size              = var.disk01["size"]
  tags              = module.label.attributes
  description       = format("%s%03d", var.disk01["memo"], count.index + 1)
}

resource "sakuracloud_disk" "disk02" {
  count             = var.server02["count"]
  name              = format("%s-%s-%03d", module.label.id, var.server02["name"], count.index + 1)
  source_archive_id = var.server02["os"] == "ubuntu18" ? data.sakuracloud_archive.ubuntu18[var.default_zone].id : var.server02["os"] == "ubuntu20" ? data.sakuracloud_archive.ubuntu20[var.default_zone].id : var.server02["os"] == "alma8" ? data.sakuracloud_archive.alma8[var.default_zone].id : var.server02["os"] == "rocky8" ? data.sakuracloud_archive.rocky8[var.default_zone].id : var.server02["os"] == "miracle8" ? data.sakuracloud_archive.miracle8[var.default_zone].id : data.sakuracloud_archive.centos7[var.default_zone].id
  plan              = var.disk02["plan"]
  connector         = var.disk02["connector"]
  size              = var.disk02["size"]
  tags              = module.label.attributes
  description       = format("%s%03d", var.disk02["memo"], count.index + 1)
}
