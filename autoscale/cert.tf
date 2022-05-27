resource "sakuracloud_proxylb_acme" "cert01" {
  proxylb_id       = sakuracloud_proxylb.elb01.id
  accept_tos       = true
  common_name      = format("%s.%s", var.elb01["name"], var.my_domain)
  update_delay_sec = 120
}

