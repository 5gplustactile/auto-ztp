resource "aws_subnet" "tf_outpost_subnet_edge_local" {
  for_each = var.instances

  vpc_id     = var.vpc_id_dt
  cidr_block = each.value
  outpost_arn = local.outpost_arn
  availability_zone = "eu-west-3a"
  enable_lni_at_device_index = 1

  tags = {
    Name =  "${each.key}-outpost-${local.region}-lni"
    availability_zone = "outpost"
  }
}

resource "aws_network_interface" "eni_lni" {
  for_each = var.instances

  subnet_id = aws_subnet.tf_outpost_subnet_edge_local[each.key].id
  tags = var.tags
}

resource "aws_network_interface_attachment" "attach_eni_lni" {
  for_each = var.instances

  instance_id   = each.key
  network_interface_id = aws_network_interface.eni_lni[each.key].id
  device_index  = 1
}