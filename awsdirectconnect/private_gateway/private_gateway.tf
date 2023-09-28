data "aws_vpn_gateway" "selected" {
  filter {
    name   = "tag:Name"
    values = ["techsol-shared-aws"]
  }
}

resource "aws_vpn_gateway_attachment" "vpn_attachment" {
  vpc_id         = module.vpc.vpc_id
  vpn_gateway_id = data.aws_vpn_gateway.selected.id
}

resource "aws_vpn_gateway_route_propagation" "example" {
  vpn_gateway_id = data.aws_vpn_gateway.selected.id
  route_table_id = module.vpc.public_route_table_ids[0]
}

