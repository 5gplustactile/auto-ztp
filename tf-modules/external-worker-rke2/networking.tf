resource "aws_subnet" "tf_outpost_subnet_edge" {
  count = local.worker_in_edge  ? 1 : 0
  vpc_id     = var.ext_vpc_id
  cidr_block = var.cidr_block_snet_op_region
  outpost_arn = local.outpost_arn
  availability_zone = "eu-west-3a"

  tags = {
  Name: "tf-outpost-${local.region}"
  availability_zone: "outpost"
  }
}

# Associate the route table with the subnet

resource "aws_route_table_association" "route_table_attach" {
  count = local.worker_in_edge ? 1 : 0

  subnet_id      = aws_subnet.tf_outpost_subnet_edge[count.index].id
  route_table_id = var.route_table_id
}

## Create a route table
#resource "aws_route_table" "rtb" {
#  vpc_id = var.ext_vpc_id
#
#  # Create a route to the Internet gateway
#  route {
#    cidr_block = "0.0.0.0/0"
#    nat_gateway_id  = var.natgw_id
#  }
#}
#
## Associate the route table with the subnet
#resource "aws_route_table_association" "rta" {
#  count = local.worker_in_edge ? 1 : 0
#  subnet_id      = aws_subnet.tf_outpost_subnet_edge[count.index].id
#  route_table_id = aws_route_table.rtb.id
#}

resource "aws_subnet" "tf_outpost_subnet_edge_local" {
  count = local.worker_in_edge ? 1 : 0
  vpc_id     = var.ext_vpc_id
  cidr_block = var.cidr_block_snet_op_local
  outpost_arn = local.outpost_arn
  availability_zone = "eu-west-3a"
  enable_lni_at_device_index = 1

  tags = {
    Name =  "tf-outpost-${local.region}-lni"
    availability_zone = "outpost"
  }
}

resource "aws_network_interface" "second_nic_workers" {
  count = length(local.edge_workers)
  subnet_id = aws_subnet.tf_outpost_subnet_edge_local[0].id
  private_ip  = local.edge_worker_ips[count.index]
  security_groups = [ module.security_group.security_group_id ]
  tags = var.tags
  
}

resource "aws_network_interface_attachment" "attach_local_nic_workers" {
  count = length(local.worker_in_edge_ids)
  instance_id          = values(local.worker_in_edge_ids)[count.index]
  network_interface_id = aws_network_interface.second_nic_workers[count.index].id
  device_index         = 1

  depends_on = [ module.ec2_instance_workers ]
}