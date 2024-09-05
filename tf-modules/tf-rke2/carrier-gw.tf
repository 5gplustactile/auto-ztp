resource "aws_ec2_carrier_gateway" "cagw" {
  count = local.worker_in_wvl ? 1 : 0

  vpc_id = module.vpc.vpc_id

  tags = var.tags
}
