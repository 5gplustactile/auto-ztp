resource "aws_subnet" "tf_outpost_subnet_edge" {
  count = local.instance_in_edge ? 1 : 0

  vpc_id     = var.vpc_id
  cidr_block = var.cidr_block_snet_op_region
  outpost_arn = local.outpost_arn
  availability_zone = "eu-west-3a"

  tags = {
    Name: "subnet-in-outpost-${local.region}"
    availability_zone: "outpost"
  }
}

# Create a route table
resource "aws_route_table" "rtb" {
  count = local.instance_in_edge ? 1 : 0

  vpc_id = var.vpc_id

  # Create a route to the Internet gateway
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id  = var.nat_gw_id
  }
}

# Associate the route table with the subnet
resource "aws_route_table_association" "rta" {
  count = local.instance_in_edge ? 1 : 0
  
  subnet_id      = aws_subnet.tf_outpost_subnet_edge[0].id
  route_table_id = aws_route_table.rtb.id
}

resource "aws_subnet" "tf_outpost_subnet_edge_local" {
  count = local.instance_in_edge ? 1 : 0

  vpc_id     = var.vpc_id
  cidr_block = var.cidr_block_snet_op_local
  outpost_arn = local.outpost_arn
  availability_zone = "eu-west-3a"
  enable_lni_at_device_index = 1

  tags = {
    Name: "subnet-lni-in-outpost-${local.region}"
    availability_zone: "outpost"
  }
}

resource "aws_network_interface" "eni_lni" {
  count = length(local.edge_instances)

  subnet_id = aws_subnet.tf_outpost_subnet_edge_local[0].id
  security_groups = [ module.security_group.security_group_id ]
  tags = var.tags
}

resource "aws_network_interface_attachment" "attach_eni_lni" {
  count = length(local.instance_in_edge_ids)

  instance_id   = values(local.instance_in_edge_ids)[count.index]
  network_interface_id = aws_network_interface.eni_lni[count.index].id
  device_index  = 1

  depends_on = [ module.ec2_instance ]
}

resource "aws_subnet" "private_region_subnet" {
#  for_each = { for k, v in var.instances : k => v if !v.instance_in_edge }
  count = local.instance_in_edge ? 0 : 1

  vpc_id     = var.vpc_id
  cidr_block = var.cidr_private_subnet
  tags = var.tags
}