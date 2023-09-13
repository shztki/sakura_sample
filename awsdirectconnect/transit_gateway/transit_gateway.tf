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

# route table create for dx_gateway
data "aws_ec2_transit_gateway_attachment" "dx_gateway" {
  filter {
    name   = "transit-gateway-id"
    values = [aws_ec2_transit_gateway.tgw.id]
  }

  filter {
    name   = "resource-type"
    values = ["direct-connect-gateway"]
  }

  filter {
    name   = "state"
    values = ["available", "pending"]
  }

  depends_on = [
    aws_dx_gateway_association.dxg_tgw,
  ]
}

#resource "aws_ec2_transit_gateway_route_table" "dx_gateway" {
#  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
#
#  tags = merge(
#    module.label.tags,
#    tomap({ Name = format("%s-dx_gateway", module.label.id) }),
#  )
#}

resource "aws_ec2_transit_gateway_route_table_association" "dx_gateway" {
  transit_gateway_attachment_id  = data.aws_ec2_transit_gateway_attachment.dx_gateway.transit_gateway_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.vpc.id
  #transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.dx_gateway.id
}

resource "aws_ec2_transit_gateway_route" "dx_gateway" {
  destination_cidr_block         = var.sakura_cidr
  transit_gateway_attachment_id  = data.aws_ec2_transit_gateway_attachment.dx_gateway.transit_gateway_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.vpc.id
  #transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.dx_gateway.id
}

