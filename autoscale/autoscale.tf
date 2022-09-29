locals {
  api_key_id               = var.api_key_id
  zone                     = var.default_zone
  elb01_name               = "elb-group" # var.server01["name"]
  lb01_name                = "lb-group"  # var.server02["name"]
  elb01_server_name_prefix = format("%s-%s", module.label.id, "elb")
  lb01_server_name_prefix  = format("%s-%s", module.label.id, "lb")
}

resource "sakuracloud_auto_scale" "elb_hscale01" {
  name  = format("%s-elb-hscale01", module.label.id)
  zones = [local.zone]

  config = jsonencode({
    resources : [{
      type : "ServerGroup",
      name : format("%s-%s", module.label.id, local.elb01_name),
      zone : local.zone,
      parent : {
        type : "ELB",
        selector : {
          names : [format("%s-%s", module.label.id, var.elb01["name"])],
        },
      },
      min_size : 0,
      max_size : 5,
      setup_grace_period : 90,
      shutdown_force : false,
      template : {
        interface_driver : "virtio",
        plan : {
          core : var.server01["core"],
          memory : var.server01["memory"],
          dedicated_cpu : false,
        },
        network_interfaces : [
          {
            upstream : {
              names : [format("%s-%s", module.label.id, var.router01["name"])],
            },
            packet_filter_id : sakuracloud_packet_filter.filter01[0].id,
            assign_cidr_block : format("%s/%s", sakuracloud_internet.router01[0].ip_addresses[2 + var.server01["count"]], var.router01["nw_mask_len"]),
            assign_netmask_len : var.router01["nw_mask_len"],
            default_route : sakuracloud_internet.router01[0].gateway,
            expose : {
              ports : [80],
              server_group_name : "gr1",
            },
          },
          {
            upstream : {
              names : [format("%s-%s", module.label.id, var.switch01["name"])],
            },
            assign_cidr_block : format("%s/%s", cidrhost(var.switch01["name"], var.server01["start_ip"] + var.server01["count"] - 1), tostring(element(regex("^\\d+.\\d+.\\d+.\\d+/(\\d+)", var.switch01["name"]), 0))),
            assign_netmask_len : tonumber(element(regex("^\\d+.\\d+.\\d+.\\d+/(\\d+)", var.switch01["name"]), 0)),
          }
        ],
        disks : [{
          source_archive : var.server01["os"] == "ubuntu18" ? data.sakuracloud_archive.ubuntu18[local.zone].id : var.server01["os"] == "ubuntu20" ? data.sakuracloud_archive.ubuntu20[local.zone].id : var.server01["os"] == "alma8" ? data.sakuracloud_archive.alma8[local.zone].id : var.server01["os"] == "rocky8" ? data.sakuracloud_archive.rocky8[local.zone].id : var.server01["os"] == "miracle8" ? data.sakuracloud_archive.miracle8[local.zone].id : data.sakuracloud_archive.centos7[local.zone].id
          plan : var.disk01["plan"],
          connection : var.disk01["connector"],
          size : var.disk01["size"],
        }],
        edit_parameter : {
          disabled : false,
          host_name_prefix : local.elb01_name,
          password : var.def_pass,
          disable_pw_auth : var.server01["disable_pw_auth"],
          enable_dhcp : false,
          change_partition_uuid : true,
          ssh_key_ids : [sakuracloud_ssh_key_gen.sshkey01.id],
          startup_scripts : [file("userdata/hscale_elb_init.sh")],
        },
      },
    }],
    autoscaler : {
      cooldown : 300,
    },
  })

  api_key_id = local.api_key_id

  cpu_threshold_scaling {
    server_prefix = local.elb01_server_name_prefix
    up            = 50
    down          = 20
  }

  depends_on = [sakuracloud_proxylb.elb01]
}

resource "sakuracloud_auto_scale" "lb_hscale01" {
  name  = format("%s-lb-hscale01", module.label.id)
  zones = [local.zone]

  config = jsonencode({
    resources : [{
      type : "ServerGroup",
      name : format("%s-%s", module.label.id, local.lb01_name),
      zone : local.zone,
      parent : {
        type : "LoadBalancer",
        selector : {
          names : [format("%s-%s", module.label.id, var.lb01["name"])],
        },
      },
      min_size : 0,
      max_size : 5,
      setup_grace_period : 90,
      shutdown_force : false,
      template : {
        interface_driver : "virtio",
        plan : {
          core : var.server02["core"],
          memory : var.server02["memory"],
          dedicated_cpu : false,
        },
        network_interfaces : [
          {
            upstream : {
              names : [format("%s-%s", module.label.id, var.switch01["name"])],
            },
            assign_cidr_block : format("%s/%s", cidrhost(var.switch01["name"], var.server02["start_ip"] + var.server02["count"] - 1), tostring(element(regex("^\\d+.\\d+.\\d+.\\d+/(\\d+)", var.switch01["name"]), 0))),
            assign_netmask_len : tonumber(element(regex("^\\d+.\\d+.\\d+.\\d+/(\\d+)", var.switch01["name"]), 0)),
            default_route : cidrhost(var.switch01["name"], var.vpc_router01["vip1"]),
            expose : {
              ports : [80],
              vips : [cidrhost(var.switch01["name"], var.lb01["vip1"])],
              health_check : {
                protocol : "http",
                path : "/",
                status_code : 200,
              },
            },
          },
        ],
        disks : [{
          source_archive : var.server02["os"] == "ubuntu18" ? data.sakuracloud_archive.ubuntu18[local.zone].id : var.server02["os"] == "ubuntu20" ? data.sakuracloud_archive.ubuntu20[local.zone].id : var.server02["os"] == "alma8" ? data.sakuracloud_archive.alma8[local.zone].id : var.server02["os"] == "rocky8" ? data.sakuracloud_archive.rocky8[local.zone].id : var.server02["os"] == "miracle8" ? data.sakuracloud_archive.miracle8[local.zone].id : data.sakuracloud_archive.centos7[local.zone].id
          plan : var.disk02["plan"],
          connection : var.disk02["connector"],
          size : var.disk02["size"],
        }],
        edit_parameter : {
          disabled : false,
          host_name_prefix : local.lb01_name,
          password : var.def_pass,
          disable_pw_auth : var.server02["disable_pw_auth"],
          enable_dhcp : false,
          change_partition_uuid : true,
          ssh_key_ids : [sakuracloud_ssh_key_gen.sshkey01.id],
          startup_scripts : [file("userdata/hscale_lb_init.sh")],
        },
      },
    }],
    autoscaler : {
      cooldown : 300,
    },
  })

  api_key_id = local.api_key_id

  cpu_threshold_scaling {
    server_prefix = local.lb01_server_name_prefix
    up            = 50
    down          = 20
  }

  depends_on = [sakuracloud_load_balancer.lb01]
}

