locals {
  zones = var.zones
}

data "sakuracloud_archive" "centos7" {
  for_each = toset(local.zones)
  zone     = each.value
  filter {
    tags = ["distro-centos", "centos-7-latest"]
  }
}

data "sakuracloud_archive" "miracle8" {
  for_each = toset(local.zones)
  zone     = each.value
  filter {
    tags = ["distro-miracle", "miracle-8-latest"]
  }
}

data "sakuracloud_archive" "alma8" {
  for_each = toset(local.zones)
  zone     = each.value
  filter {
    tags = ["distro-alma", "alma-8-latest"]
  }
}

data "sakuracloud_archive" "rocky8" {
  for_each = toset(local.zones)
  zone     = each.value
  filter {
    tags = ["distro-rocky", "rocky-8-latest"]
  }
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

