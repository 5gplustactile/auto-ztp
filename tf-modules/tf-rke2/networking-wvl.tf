module "vpc_wvl" {
  count = local.worker_in_wvl ? 1 : 0

  source = "terraform-aws-modules/vpc/aws"

  name = "${var.vpc_name}-wvl"
  cidr = var.vpc_cidr_wvl

  azs             = local.parent_azs_wvl
  private_subnets =  var.private_subnets_wvl
  public_subnets  =  var.public_subnets_wvl

  enable_nat_gateway = false
  single_nat_gateway = false

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/cluster-mgmt": "shared"
  }
  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/cluster-mgmt": "shared"
  }
  tags = var.tags
}

resource "aws_nat_gateway" "natgw" {
  count = local.worker_in_wvl ? 1 : 0

  allocation_id = aws_eip.nat.id
  subnet_id     = module.vpc_wvl.private_subnets
  tags          = var.tags
}

resource "aws_eip" "nat" {
  count = local.worker_in_wvl ? 1 : 0

  associate_with_private_ip = null
  tags = var.tags
}


resource "aws_subnet" "tf_subnet_wvl" {
  count = local.worker_in_wvl ? 1 : 0

  vpc_id     = module.vpc_wvl.vpc_id
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

  vpc_id = module.vpc_wvl.vpc_id

  # Create a route to the Internet gateway
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.natgw.id
  }
}

# Create a cgw wavelength route table
resource "aws_route_table" "rtb_wvl_cgw" {
  count = local.worker_in_wvl ? 1 : 0

  vpc_id = module.vpc_wvl.vpc_id

  # Create a route to the carrier gateway
  route {
    cidr_block = "0.0.0.0/0"
    carrier_gateway_id = aws_ec2_carrier_gateway.cagw[count.index].id
  }
}

# Create a tgw wavelength route table
resource "aws_route_table" "rtb_wvl_tgw" {
  count = local.worker_in_wvl ? 1 : 0

  vpc_id = module.vpc_wvl.vpc_id

  # Create a route to the transit gateway
  route {
    cidr_block = var.vpc_cidr
    transit_gateway_id = aws_ec2_transit_gateway.tgw.id[count.index]
  }
}

# Associate the route natgw table with the subnet
resource "aws_route_table_association" "rta_natgw" {
  count = local.worker_in_wvl ? 1 : 0

  subnet_id      = module.vpc_wvl.private_subnets
  route_table_id = aws_route_table.rtb_natgw.id
}

# Associate the route table cgw with the wavelength subnet
resource "aws_route_table_association" "rta_wvl_cgw" {
  count = local.worker_in_wvl ? 1 : 0
  subnet_id      = aws_subnet.tf_subnet_wvl[count.index].id
  route_table_id = aws_route_table.rtb_wvl_cgw[count.index].id
}

# Associate the route table tgw with the wavelength subnet
resource "aws_route_table_association" "rta_wvl_tgw" {
  count = local.worker_in_wvl ? 1 : 0
  subnet_id      = aws_subnet.tf_subnet_wvl[count.index].id
  route_table_id = aws_route_table.rtb_wvl_tgw[count.index].id
}

# Associate the route table tgw with the region subnet
resource "aws_route_table_association" "rta_wvl_tgw_region" {
  count = local.worker_in_wvl ? 1 : 0
  subnet_id      = module.vpc_wvl.private_subnets
  route_table_id = aws_route_table.rtb_wvl_tgw[count.index].id
}