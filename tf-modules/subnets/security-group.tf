module "sgs_vpc_peering" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = "vpc_peering_cluster_api_to_cluster_mgmt"
  description = "Allow traffic from cluster mgmt"
  vpc_id      = var.vpc_id_dt

  ingress_cidr_blocks = [var.cidr_block_vpc_cluster_dc]
  ingress_rules       = ["all-all"]
  egress_rules        = ["all-all"]

  tags = var.tags
}