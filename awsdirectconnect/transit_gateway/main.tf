terraform {
  required_version = "~> 1.5"
  cloud {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

module "label" {
  source      = "cloudposse/label/null"
  namespace   = var.label["namespace"]
  stage       = var.label["stage"]
  name        = var.label["name"]
  delimiter   = "-"
  label_order = ["namespace", "stage", "name"]
}

