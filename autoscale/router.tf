resource "sakuracloud_internet" "router01" {
  count       = var.router01["count"]
  name        = format("%s-%s", module.label.id, var.router01["name"])
  netmask     = var.router01["nw_mask_len"]
  band_width  = var.router01["band_width"]
  enable_ipv6 = var.router01["enable_ipv6"]
  description = var.router01["memo"]
  tags        = module.label.attributes
}




