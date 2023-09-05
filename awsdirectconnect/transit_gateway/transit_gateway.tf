resource "aws_ec2_transit_gateway" "tgw" {
  description                     = "sakura connect test"
  amazon_side_asn                 = "64513"
  dns_support                     = "enable"
  vpn_ecmp_support                = "enable"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  multicast_support               = "disable"
  auto_accept_shared_attachments  = "disable"
  tags                            = module.label.tags
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc" {
  subnet_ids                                      = [module.vpc.private_subnets[2], module.vpc.private_subnets[3]]
  transit_gateway_id                              = aws_ec2_transit_gateway.tgw.id
  vpc_id                                          = module.vpc.vpc_id
  dns_support                                     = "enable"
  transit_gateway_default_route_table_association = true
  transit_gateway_default_route_table_propagation = true
  tags                                            = module.label.tags
}
