resource "aws_ec2_carrier_gateway" "cagw" {
  count = local.worker_in_wvl ? 1 : 0

  vpc_id = aws_vpc.vpc_wvl[0].id

  tags = var.tags
}
