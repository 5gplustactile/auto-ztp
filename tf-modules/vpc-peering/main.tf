resource "aws_vpc_peering_connection" "peer" {
  vpc_id        = var.vpc_id_cluster_dc
  peer_vpc_id   = var.vpc_id_dt
  auto_accept   = true

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  tags = var.tags
}

resource "aws_route" "route_vpc_dt" {
  for_each = toset(var.list_route_table_id_cluster_dc)

  route_table_id         = each.value
  destination_cidr_block = var.dest_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}

resource "aws_route" "route_vpc_central_dc" {
  route_table_id         = var.rt_id_private_digital_twins
  destination_cidr_block = var.cidr_block_vpc_cluster_dc
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}