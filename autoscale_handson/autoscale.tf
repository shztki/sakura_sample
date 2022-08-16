locals {
  api_key_id = var.api_key_id
  zone       = var.default_zone
}

resource "sakuracloud_auto_scale" "autoscale01" {
  name       = var.autoscale01["name"]
  zones      = [local.zone]
  api_key_id = local.api_key_id

  cpu_threshold_scaling {
    server_prefix = var.server02["name"]
    up            = var.autoscale01["cpu_up"]
    down          = var.autoscale01["cpu_down"]
  }

  config      = file(var.autoscale01["file"])
  description = format("%s", var.autoscale01["memo"])

  depends_on = [sakuracloud_proxylb.elb01]
}

resource "sakuracloud_auto_scale" "autoscale02" {
  name       = var.autoscale02["name"]
  zones      = [local.zone]
  api_key_id = local.api_key_id

  cpu_threshold_scaling {
    server_prefix = trimsuffix(var.server03["name"], "-base")
    up            = var.autoscale02["cpu_up"]
    down          = var.autoscale02["cpu_down"]
  }

  config      = file(var.autoscale02["file"])
  description = format("%s", var.autoscale02["memo"])

  depends_on = [sakuracloud_proxylb.elb02]
}
