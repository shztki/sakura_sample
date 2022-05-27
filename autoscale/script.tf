resource "sakuracloud_note" "script01" {
  name    = format("%s-%s", module.label.id, var.script01["name"])
  class   = var.script01["class"]
  content = file(var.script01["file"])
  tags    = module.label.attributes
}

resource "sakuracloud_note" "script02" {
  name    = format("%s-%s", module.label.id, var.script02["name"])
  class   = var.script02["class"]
  content = file(var.script02["file"])
  tags    = module.label.attributes
}
