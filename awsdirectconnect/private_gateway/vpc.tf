module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = module.label.id
  cidr = var.vpc.cidr

  #azs             = ["ap-northeast-1a", "ap-northeast-1c"]
  azs             = ["apne1-az4", "apne1-az1"]
  public_subnets  = ["172.16.0.0/24", "172.16.1.0/24"]
  private_subnets = ["172.16.10.0/24", "172.16.11.0/24", "172.16.255.0/27", "172.16.255.32/27"]

  enable_nat_gateway   = false
  enable_vpn_gateway   = false
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    module.label.tags,
    tomap({ Name = module.label.id }),
  )
}
