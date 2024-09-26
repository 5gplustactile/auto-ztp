resource "aws_ec2_transit_gateway" "tgw" {
  description = "Transit Gateway to connect multiple edge and regions"
  amazon_side_asn = 64512
  auto_accept_shared_attachments = "disable"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  dns_support = "enable"
  vpn_ecmp_support = "enable"
  tags = var.tags
}

# tgw attachment to vpc edge (outpost)
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attachment_edge" {
  count = local.worker_in_edge || local.control_plane_in_edge || var.enable_bastion_host ? 1 : 0

  subnet_ids = [ aws_subnet.tf_outpost_subnet_edge[count.index].id, module.vpc.public_subnets[1] ]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id = module.vpc.vpc_id
  tags = {
    Name: "tf-tgw-attachment-edge"
  }
}

# tgw attachment to vpc wvl (wavelength)
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attachment_wvl" {
  count = local.worker_in_wvl ? 1 : 0

  subnet_ids = [ module.vpc_wvl[count.index].public_subnet, module.vpc_wvl[count.index].private_subnets ]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id = module.vpc_wvl[count.index].vpc_id
  tags = {
    Name: "tf-tgw-attachment-wvl"
  }
}