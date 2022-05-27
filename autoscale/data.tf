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

data "sakuracloud_archive" "vsrx_std_100" {
  for_each = toset(local.zones)
  zone     = each.value
  filter {
    names = ["Juniper vSRX スタンダード"]
  }
}

data "sakuracloud_archive" "win2019" {
  for_each = toset(local.zones)
  zone     = each.value
  os_type  = "windows2019"
}

data "sakuracloud_archive" "win2019_rds" {
  for_each = toset(local.zones)
  zone     = each.value
  os_type  = "windows2019-rds"
}

data "sakuracloud_archive" "win2016_rds" {
  for_each = toset(local.zones)
  zone     = each.value
  os_type  = "windows2016-rds"
}

data "sakuracloud_archive" "win2016_sql_std" {
  for_each = toset(local.zones)
  zone     = each.value
  os_type  = "windows2016-sql-standard"
}
