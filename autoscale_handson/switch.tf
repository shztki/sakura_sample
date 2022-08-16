resource "sakuracloud_switch" "switch01" {
  #zone = var.default_zone
  name = format("%s", var.switch01["memo"])
  #description = var.switch01["memo"]
  #tags = module.label.attributes
  tags = concat(module.label.attributes, [var.switch01["memo"]])
}

resource "sakuracloud_switch" "switch02" {
  #zone = var.default_zone
  name = format("%s", var.switch02["memo"])
  #description = var.switch02["memo"]
  #tags = module.label.attributes
  tags = concat(module.label.attributes, [var.switch02["memo"]])
}

