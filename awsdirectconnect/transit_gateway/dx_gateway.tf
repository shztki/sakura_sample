resource "aws_dx_gateway" "dxg" {
  name            = module.label.id
  amazon_side_asn = "64512"
}

resource "aws_dx_gateway_association" "dxg_tgw" {
  dx_gateway_id         = aws_dx_gateway.dxg.id
  associated_gateway_id = aws_ec2_transit_gateway.tgw.id

  allowed_prefixes = [
    var.vpc_cidr,
  ]
}
