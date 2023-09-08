data "http" "ip_address" {
  url = "https://api.ipify.org/"
}

locals {
  office_ip_address  = format("%s/32,%s,%s,%s", trimspace(data.http.ip_address.response_body), var.office_cidr, var.sakura_cidr, var.vpc.cidr)
  private_ip_address = format("%s,%s", var.sakura_cidr, var.vpc.cidr)
}

module "allow_office_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = format("%s-allow-office-sg", module.label.id)
  description = "allow access from office"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "ssh access"
      cidr_blocks = local.office_ip_address
    },
    {
      from_port   = "-1"
      to_port     = "-1"
      protocol    = "icmp"
      description = "icmp access"
      cidr_blocks = local.office_ip_address
    },
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "out going"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = merge(
    module.label.tags,
    tomap({ Name = module.label.id }),
  )
}

module "allow_private_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = format("%s-allow-private-sg", module.label.id)
  description = "allow access from private"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "ssh access"
      cidr_blocks = local.private_ip_address
    },
    {
      from_port   = "-1"
      to_port     = "-1"
      protocol    = "icmp"
      description = "icmp access"
      cidr_blocks = local.private_ip_address
    },
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "out going"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = merge(
    module.label.tags,
    tomap({ Name = module.label.id }),
  )
}
