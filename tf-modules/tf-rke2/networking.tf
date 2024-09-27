resource "aws_vpc" "vpc" {

  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "${var.vpc_name}-edge"
  }
}

resource "aws_subnet" "vpc_public_subnets" {
  count = length([for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k + 48)])

  vpc_id            = aws_vpc.vpc.id
  map_public_ip_on_launch = true
  cidr_block        = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k + 48)]
  availability_zone = element(local.azs, count.index)

  tags = {
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/cluster-mgmt": "shared"
  }
}

resource "aws_subnet" "vpc_private_subnets" {
  count = length([for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k)])
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k)]
  availability_zone = element(local.azs, count.index)

  tags = {
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/cluster-mgmt": "shared"
  }
}

resource "aws_internet_gateway" "vpc_igw" {
  vpc_id = aws_vpc.vpc.id

  tags = var.tags
}

resource "aws_route_table" "rtb_vpc_public_subnets" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_igw.id
  }
}

resource "aws_route_table_association" "rta_public_subnets" {
  count = length([for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k + 48)])

  subnet_id    = aws_subnet.vpc_public_subnets[count.index].id
  route_table_id = aws_route_table.rtb_vpc_public_subnets.id
}

resource "aws_eip" "vpc_nat" {
  associate_with_private_ip = null
  tags = {
    Name = "${var.vpc_name}-edge"
  }
}

resource "aws_nat_gateway" "vpc_natgw" {
  allocation_id = aws_eip.vpc_nat.id
  subnet_id     = aws_subnet.vpc_public_subnets[0].id
  tags          = var.tags
}

resource "aws_route_table" "rtb_vpc_private" {
  vpc_id = aws_vpc.vpc.id

  # Create a route to the nat gateway
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.vpc_natgw.id
  }

  # Create a route to the transit gateway
  route {
    cidr_block = var.vpc_cidr_wvl
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }
}

resource "aws_route_table_association" "rta_private_subnets" {
  count = length([for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k)])
  
  subnet_id    = aws_subnet.vpc_private_subnets[count.index].id
  route_table_id = aws_route_table.rtb_vpc_private.id
}

resource "aws_subnet" "tf_outpost_subnet_edge" {
  count = local.worker_in_edge || local.control_plane_in_edge || var.enable_bastion_host ? 1 : 0
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.cidr_block_snet_op_region
  outpost_arn = local.outpost_arn
  availability_zone = local.az_to_subnet_edge

  tags = {
  Name: "tf-outpost-${local.region}"
  availability_zone: "outpost"
  }
}

# Create a route table
resource "aws_route_table" "rtb" {
  vpc_id = aws_vpc.vpc.id

  # Create a route to the Internet gateway
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.vpc_natgw.id
  }

  # Create a route to the transit gateway
  route {
    cidr_block = var.vpc_cidr_wvl
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }
}

# Associate the route table with the subnet
resource "aws_route_table_association" "rta" {
  count = local.worker_in_edge || local.control_plane_in_edge || var.enable_bastion_host ? 1 : 0
  subnet_id      = aws_subnet.tf_outpost_subnet_edge[count.index].id
  route_table_id = aws_route_table.rtb.id
}

resource "aws_subnet" "tf_outpost_subnet_edge_local" {
  count = local.worker_in_edge || local.control_plane_in_edge || var.enable_bastion_host ? 1 : 0
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.cidr_block_snet_op_local
  outpost_arn = local.outpost_arn
  availability_zone = "eu-west-3a"
  enable_lni_at_device_index = 1

  tags = {
    Name =  "tf-outpost-${local.region}-lni"
    availability_zone = "outpost"
  }
}

resource "aws_network_interface" "second_nic_masters" {
  count = length(local.edge_masters)
  subnet_id = aws_subnet.tf_outpost_subnet_edge_local[0].id
  private_ip  = local.edge_master_ips[count.index]
  security_groups = [ module.security_group.security_group_id ]
  tags = var.tags
  
}

resource "aws_network_interface" "second_nic_workers" {
  count = length(local.edge_workers)
  subnet_id = aws_subnet.tf_outpost_subnet_edge_local[0].id
  private_ip  = local.edge_worker_ips[count.index]
  security_groups = [ module.security_group.security_group_id ]
  tags = var.tags
  
}

resource "aws_network_interface_attachment" "attach_local_nic_masters" {
  count = length(local.master_in_edge_ids)
  instance_id          = values(local.master_in_edge_ids)[count.index]
  network_interface_id = aws_network_interface.second_nic_masters[count.index].id
  device_index         = 1

  depends_on = [ module.ec2_instance ]
}


resource "aws_network_interface_attachment" "attach_local_nic_workers" {
  count = length(local.worker_in_edge_ids)
  instance_id          = values(local.worker_in_edge_ids)[count.index]
  network_interface_id = aws_network_interface.second_nic_workers[count.index].id
  device_index         = 1

  depends_on = [ module.ec2_instance_workers ]
}