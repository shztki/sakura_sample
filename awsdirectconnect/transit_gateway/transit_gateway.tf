resource "aws_ec2_transit_gateway" "tgw" {
  description                     = "sakura connect test"
  amazon_side_asn                 = "64513"
  dns_support                     = "enable"
  vpn_ecmp_support                = "enable"
  default_route_table_association = "disable" # "enable"
  default_route_table_propagation = "disable" # "enable"
  multicast_support               = "disable"
  auto_accept_shared_attachments  = "disable"
  tags                            = module.label.tags
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc" {
  subnet_ids                                      = [module.vpc.private_subnets[2], module.vpc.private_subnets[3]]
  transit_gateway_id                              = aws_ec2_transit_gateway.tgw.id
  vpc_id                                          = module.vpc.vpc_id
  dns_support                                     = "enable"
  transit_gateway_default_route_table_association = false # true
  transit_gateway_default_route_table_propagation = false # true
  tags                                            = module.label.tags
}

resource "aws_ec2_transit_gateway_route_table" "vpc" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id

  tags = merge(
    module.label.tags,
    tomap({ Name = format("%s-vpc", module.label.id) }),
  )
}

resource "aws_ec2_transit_gateway_route_table_association" "vpc" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.vpc.id
}

#resource "aws_ec2_transit_gateway_route_table_propagation" "vpc" {
#  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc.id
#  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.vpc.id
#}
resource "aws_ec2_transit_gateway_route" "vpc" {
  destination_cidr_block         = var.vpc_cidr
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.vpc.id
}

resource "aws_route" "public_vpc_sakura" {
  route_table_id         = module.vpc.public_route_table_ids[0]
  destination_cidr_block = var.sakura_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.tgw.id
}

#resource "aws_route" "private0_vpc_sakura" {
#  route_table_id         = module.vpc.private_route_table_ids[0]
#  destination_cidr_block = var.sakura_cidr
#  transit_gateway_id     = aws_ec2_transit_gateway.tgw.id
#}
#
#resource "aws_route" "private1_vpc_sakura" {
#  route_table_id         = module.vpc.private_route_table_ids[1]
#  destination_cidr_block = var.sakura_cidr
#  transit_gateway_id     = aws_ec2_transit_gateway.tgw.id
#}
