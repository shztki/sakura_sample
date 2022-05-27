resource "sakuracloud_proxylb" "elb01" {
  region         = var.elb01["region"]
  name           = format("%s-%s", module.label.id, var.elb01["name"])
  plan           = var.elb01["plan"]
  vip_failover   = var.elb01["vip_failover"]
  sticky_session = var.elb01["sticky_session"]
  gzip           = var.elb01["gzip"]
  timeout        = var.elb01["timeout"]
  description    = var.elb01["memo"]
  tags           = module.label.attributes

  health_check {
    protocol   = "http"
    path       = "/"
    delay_loop = 10
  }

  bind_port {
    proxy_mode = "http"
    port       = 80
    #redirect_to_https = true
  }
  bind_port {
    proxy_mode    = "https"
    port          = 443
    support_http2 = true
  }

  rule {
    action = "forward"
    path   = "/*"
    group  = "gr1"
  }

  dynamic "server" {
    for_each = sakuracloud_server.server01
    content {
      ip_address = server.value.ip_address
      port       = 80
      group      = "gr1"
    }
  }

}
