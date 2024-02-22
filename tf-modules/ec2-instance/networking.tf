data "aws_vpc" "vpc_dc" {
  id = var.vpc_id
}

resource "aws_subnet" "tf_outpost_subnet_edge" {
  for_each = { for k, v in var.instances : k => v if v.instance_in_edge }

  vpc_id     = var.vpc_id
  cidr_block = var.cidr_block_snet_op_region
  outpost_arn = local.outpost_arn
  availability_zone = "eu-west-3a"

  tags = var.tags
}

resource "aws_subnet" "tf_outpost_subnet_edge_local" {
  for_each = { for k, v in var.instances : k => v if v.instance_in_edge }

  vpc_id     = var.vpc_id
  cidr_block = var.cidr_block_snet_op_region
  outpost_arn = local.outpost_arn
  availability_zone = "eu-west-3a"
  enable_lni_at_device_index = 1

  tags = var.tags
}

resource "aws_network_interface" "eni_lni" {
  for_each = { for k, v in var.instances : k => v if v.instance_in_edge }

  subnet_id = aws_subnet.tf_outpost_subnet_edge_local[each.key].id
  tags = var.tags
}

resource "aws_network_interface_attachment" "attach_eni_lni" {
  for_each = { for k, v in var.instances : k => v if v.instance_in_edge }

  instance_id   = each.key
  network_interface_id = aws_network_interface.eni_lni[each.key].id
  device_index  = 1
}

resource "aws_subnet" "private_region_subnet" {
  for_each = { for k, v in var.instances : k => v if !v.instance_in_edge }

  vpc_id     = var.vpc_id
  cidr_block = var.cidr_private_subnet
  tags = var.tags
}