provider "sakuracloud" {
  zone = var.default_zone
}

module "label" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=master"
  namespace   = var.label["namespace"]
  stage       = var.label["stage"]
  name        = var.label["name"]
  attributes  = [var.label["namespace"], var.label["stage"], var.label["name"]]
  delimiter   = "-"
  label_order = ["namespace", "stage", "name"]
}

terraform {
  required_version = "~> 1.2"

  required_providers {
    sakuracloud = {
      source  = "sacloud/sakuracloud"
      version = "~> 2.16.2"
    }
  }
}
