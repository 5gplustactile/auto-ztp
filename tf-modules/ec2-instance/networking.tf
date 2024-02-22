resource "aws_subnet" "tf_outpost_subnet_edge" {
  count = local.instance_in_edge ? 1 : 0
  vpc_id     = var.vpc_id
  cidr_block = var.cidr_block_snet_op_region
  outpost_arn = local.outpost_arn
  availability_zone = "eu-west-3a"

  tags = var.tags
}

resource "aws_subnet" "private_region_subnet" {
  count = local.instance_in_edge ? 0 : 1
  vpc_id     = var.vpc_id

  tags = var.tags
}