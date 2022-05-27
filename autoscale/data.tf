locals {
  zones = var.zones
}

data "sakuracloud_archive" "centos7" {
  for_each = toset(local.zones)
  zone     = each.value
  os_type  = "centos7"
}

data "sakuracloud_archive" "centos8" {
  for_each = toset(local.zones)
  zone     = each.value
  os_type  = "centos8stream"
}

data "sakuracloud_archive" "miracle8" {
  for_each = toset(local.zones)
  zone     = each.value
  os_type  = "miraclelinux"
}

data "sakuracloud_archive" "alma8" {
  for_each = toset(local.zones)
  zone     = each.value
  os_type  = "almalinux"
}

data "sakuracloud_archive" "rocky8" {
  for_each = toset(local.zones)
  zone     = each.value
  os_type  = "rockylinux"
}

data "sakuracloud_archive" "ubuntu18" {
  for_each = toset(local.zones)
  zone     = each.value
  os_type  = "ubuntu1804"
}

data "sakuracloud_archive" "ubuntu20" {
  for_each = toset(local.zones)
  zone     = each.value
  os_type  = "ubuntu2004"
}

