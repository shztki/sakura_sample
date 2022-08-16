#output "server01_ip" {
#  value = sakuracloud_server.server01.*.ip_address
#}
#output "server02_ip" {
#  value = sakuracloud_server.server02.*.ip_address
#}
#output "server03_ip" {
#  value = sakuracloud_server.server03.*.ip_address
#}
output "elb01_vip" {
  value = sakuracloud_proxylb.elb01.vip
}
output "elb02_vip" {
  value = sakuracloud_proxylb.elb02.vip
}
