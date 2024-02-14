module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = local.azs
  private_subnets =  [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k)]
  public_subnets  =  [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k + 48)]

  enable_nat_gateway = true
  single_nat_gateway = true

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }
  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }
  tags = var.tags
}

# Create a route table
resource "aws_route_table" "rtb" {
  vpc_id = module.vpc.vpc_id

  # Create a route to the Internet gateway
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id  = module.vpc.natgw_ids[0]
  }
  
  route {
    cidr_block = var.vpc_cidr
    gateway_id = "local"
  }
}