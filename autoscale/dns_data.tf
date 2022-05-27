# DNSゾーン参照
data "sakuracloud_dns" "dns" {
  filter {
    names = [var.my_domain]
  }
}

#resource "sakuracloud_dns_record" "record_server01" {
#  dns_id = data.sakuracloud_dns.dns.id
#  count  = var.server01["count"]
#  name   = format("%s%03d", var.server01["name"], count.index + 1)
#  type   = "A"
#  ttl    = 300
#  value  = sakuracloud_internet.router01[0].ip_addresses[count.index + 3]
#  #  value  = element(sakuracloud_server.server01.*.ip_address, count.index)
#}

#resource "sakuracloud_dns_record" "record_gslb" {
#  dns_id = data.sakuracloud_dns.dns.id
#  name   = "@"
#  type   = "A"
#  ttl    = 300
#  value  = format("%s.", sakuracloud_gslb.gslb.fqdn)
#}

#resource "sakuracloud_dns_record" "record_lb01" {
#  dns_id = data.sakuracloud_dns.dns.id
#  name   = var.lb01["name"]
#  type   = "A"
#  ttl    = 300
#  value  = sakuracloud_internet.router01[0].ip_addresses[var.server01["count"] + 3]
#}

resource "sakuracloud_dns_record" "record_elb01" {
  dns_id = data.sakuracloud_dns.dns.id
  name   = var.elb01["name"]
  type   = "ALIAS" # "CNAME"
  ttl    = 60
  #  value = sakuracloud_proxylb.elb01.vip
  value = format("%s.", sakuracloud_proxylb.elb01.fqdn)
}
