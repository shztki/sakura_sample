resource "sakuracloud_proxylb" "elb01" {
  region         = var.elb01["region"]
  name           = format("%s", var.elb01["name"])
  plan           = var.elb01["plan"]
  vip_failover   = var.elb01["vip_failover"]
  sticky_session = var.elb01["sticky_session"]
  gzip           = var.elb01["gzip"]
  timeout        = var.elb01["timeout"]
  description    = var.elb01["memo"]
  #tags           = module.label.attributes
  tags = concat(module.label.attributes, [var.elb01["name"]])

  health_check {
    protocol   = "http"
    path       = "/"
    delay_loop = 10
  }

  bind_port {
    proxy_mode = "http"
    port       = 80
  }

  #rule {
  #  action = "forward"
  #  path   = "/*"
  #  group  = "gr1"
  #}

  dynamic "server" {
    for_each = sakuracloud_server.server02
    content {
      ip_address = server.value.ip_address
      port       = 80
      #group      = "gr1"
    }
  }
}

resource "sakuracloud_proxylb" "elb02" {
  region         = var.elb02["region"]
  name           = format("%s", var.elb02["name"])
  plan           = var.elb02["plan"]
  vip_failover   = var.elb02["vip_failover"]
  sticky_session = var.elb02["sticky_session"]
  gzip           = var.elb02["gzip"]
  timeout        = var.elb02["timeout"]
  description    = var.elb02["memo"]
  #tags           = module.label.attributes
  tags = concat(module.label.attributes, [var.elb02["name"]])

  health_check {
    protocol   = "http"
    path       = "/"
    delay_loop = 10
  }

  bind_port {
    proxy_mode = "http"
    port       = 80
  }

  #rule {
  #  action = "forward"
  #  path   = "/*"
  #  group  = "gr1"
  #}

  dynamic "server" {
    for_each = sakuracloud_server.server03
    content {
      ip_address = server.value.ip_address
      port       = 80
      #group      = "gr1"
    }
  }
}
