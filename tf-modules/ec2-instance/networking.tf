resource "aws_subnet" "tf_outpost_subnet_edge" {
  for_each = { for k, v in var.instances : k => v if v.instance_in_edge }

  vpc_id     = var.vpc_id
  cidr_block = var.cidr_block_snet_op_region
  outpost_arn = local.outpost_arn
  availability_zone = "eu-west-3a"

  tags = var.tags
}

resource "aws_subnet" "private_region_subnet" {
  for_each = { for k, v in var.instances : k => v if !v.instance_in_edge }

  vpc_id     = var.vpc_id
  tags = var.tags
}