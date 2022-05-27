resource "sakuracloud_note" "autoscale_centos_lb_init" {
  name    = "autoscale_centos_lb_init"
  class   = "shell"
  content = file("userdata/autoscale_centos_lb_init.sh")
  tags    = module.label.attributes
}

resource "sakuracloud_note" "autoscale_centos_elb_init" {
  name    = "autoscale_centos_elb_init"
  class   = "shell"
  content = file("userdata/autoscale_centos_elb_init.sh")
  tags    = module.label.attributes
}
