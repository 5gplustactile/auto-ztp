### subnets to clusters digital-twins 

## private subnets
resource "aws_subnet" "subnet" {
  for_each = { for subnet in local.flattened_subnets : "${subnet.dt}-${subnet.cidr_block}" => subnet }

  vpc_id     = var.vpc_id_dt
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.az

  tags = var.tags
}

## subnets to outpost
resource "aws_subnet" "tf_outpost_subnet_edge" {
  for_each = var.subnet_outpost

  vpc_id     = var.vpc_id_dt
  cidr_block = each.value.cidr_block_snet_op_region
  outpost_arn = local.outpost_arn
  availability_zone = "eu-west-3a"

  tags = {
  Name: "${each.key}-outpost-${local.region}"
  availability_zone: "outpost"
  }
}

# Associate the route table with the subnet

resource "aws_route_table_association" "route_table_attach" {
  for_each = aws_subnet.subnet

  subnet_id      = each.value.id
  route_table_id = var.route_table_id
}

resource "aws_route_table_association" "route_table_attach_op" {
  for_each = aws_subnet.tf_outpost_subnet_edge

  subnet_id      = each.value.id
  route_table_id = var.route_table_id
}