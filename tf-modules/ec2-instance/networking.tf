resource "aws_subnet" "tf_outpost_subnet_edge" {
  count = local.instance_in_edge ? 1 : 0

  vpc_id     = var.vpc_id
  cidr_block = var.cidr_block_snet_op_region
  outpost_arn = local.outpost_arn
  availability_zone = "eu-west-3a"

  tags = var.tags
}

resource "aws_network_interface" "eni_lni" {
  count = length(local.edge_instances)

  subnet_id = aws_subnet.tf_outpost_subnet_edge[0].id
  security_groups = [ module.security_group.security_group_id ]
  tags = var.tags
}

resource "aws_network_interface_attachment" "attach_eni_lni" {
  count = length(local.instance_in_edge_ids)

  instance_id   = values(local.instance_in_edge_ids)[count.index]
  network_interface_id = aws_network_interface.eni_lni[count.index].id
  device_index  = 1
}

resource "aws_subnet" "private_region_subnet" {
  for_each = { for k, v in var.instances : k => v if !v.instance_in_edge }

  vpc_id     = var.vpc_id
  cidr_block = var.cidr_private_subnet
  tags = var.tags
}