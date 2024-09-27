resource "aws_vpc" "vpc_wvl" {
  count = local.worker_in_wvl ? 1 : 0

  cidr_block = var.vpc_cidr_wvl
  tags = {
    Name = "${var.vpc_name}-wvl"
  }
}

resource "aws_subnet" "public_subnets" {
  count             = local.worker_in_wvl ? length(var.public_subnets_wvl) : 0
  vpc_id            = aws_vpc.vpc_wvl[0].id
  map_public_ip_on_launch = true
  cidr_block        = var.public_subnets_wvl[count.index]
  availability_zone = element(local.parent_azs_wvl, count.index)

  tags = {
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/cluster-mgmt": "shared"
  }
}

resource "aws_subnet" "private_subnets" {
  count             = local.worker_in_wvl ? length(var.private_subnets_wvl) : 0
  vpc_id            = aws_vpc.vpc_wvl[0].id
  cidr_block        = var.private_subnets_wvl[count.index]
  availability_zone = element(local.parent_azs_wvl, count.index)

  tags = {
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/cluster-mgmt": "shared"
  }
}

resource "aws_internet_gateway" "igw_wvl" {
  count  = local.worker_in_wvl ? 1 : 0
  vpc_id = aws_vpc.vpc_wvl[0].id
}

resource "aws_route_table" "rtb_public" {
  count  = local.worker_in_wvl ? 1 : 0
  vpc_id = aws_vpc.vpc_wvl[0].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_wvl[0].id
  }
}

resource "aws_route_table_association" "public_subnets" {
  count        = local.worker_in_wvl ? length(var.public_subnets_wvl) : 0
  subnet_id    = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.rtb_public[0].id
}

resource "aws_route_table" "rtb_private" {
  count  = local.worker_in_wvl ? 1 : 0
  vpc_id = aws_vpc.vpc_wvl[0].id
}

resource "aws_route_table_association" "private_subnets" {
  count        = local.worker_in_wvl ? length(var.private_subnets_wvl) : 0
  subnet_id    = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.rtb_private[0].id
}

resource "aws_eip" "nat" {
  count = local.worker_in_wvl ? 1 : 0

  associate_with_private_ip = null
  tags = var.tags
}

resource "aws_nat_gateway" "natgw" {
  count = local.worker_in_wvl ? 1 : 0

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.private_subnets[0].id
  tags          = var.tags
}


resource "aws_subnet" "tf_subnet_wvl" {
  count = local.worker_in_wvl ? 1 : 0

  vpc_id     = aws_vpc.vpc_wvl[0].id
  cidr_block = var.cidr_block_snet_wvl
  availability_zone = local.az_wvl

  tags = {
  Name: "tf-wvl-${local.region}"
  availability_zone: "wavelength"
  }
}

# Create a route ngw table
resource "aws_route_table" "rtb_natgw" {
  count = local.worker_in_wvl ? 1 : 0

  vpc_id = aws_vpc.vpc_wvl[0].id

  # Create a route to the Internet gateway
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.natgw[0].id
  }
}

# Create a cgw wavelength route table
resource "aws_route_table" "rtb_wvl_cgw" {
  count = local.worker_in_wvl ? 1 : 0

  vpc_id = aws_vpc.vpc_wvl[0].id

  # Create a route to the carrier gateway
  route {
    cidr_block = "0.0.0.0/0"
    carrier_gateway_id = aws_ec2_carrier_gateway.cagw[0].id
  }
}

# Create a tgw wavelength route table
resource "aws_route_table" "rtb_wvl_tgw" {
  count = local.worker_in_wvl ? 1 : 0

  vpc_id = aws_vpc.vpc_wvl[0].id

  # Create a route to the transit gateway
  route {
    cidr_block = var.vpc_cidr
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  }
}

# Associate the route natgw table with the subnet
resource "aws_route_table_association" "rta_natgw" {
#  count = local.worker_in_wvl ? 1 : 0
  count        = local.worker_in_wvl ? length(var.private_subnets_wvl) : 0

  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.rtb_natgw[0].id
}

# Associate the route table cgw with the wavelength subnet
resource "aws_route_table_association" "rta_wvl_cgw" {
  count = local.worker_in_wvl ? 1 : 0
  subnet_id      = aws_subnet.tf_subnet_wvl[0].id
  route_table_id = aws_route_table.rtb_wvl_cgw[0].id
}

# Associate the route table tgw with the wavelength subnet
resource "aws_route_table_association" "rta_wvl_tgw" {
  count = local.worker_in_wvl ? 1 : 0
  subnet_id      = aws_subnet.tf_subnet_wvl[0].id
  route_table_id = aws_route_table.rtb_wvl_tgw[0].id
}

# Associate the route table tgw with the region subnet
resource "aws_route_table_association" "rta_wvl_tgw_region" {
  count = local.worker_in_wvl ? 1 : 0
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.rtb_wvl_tgw[0].id
}