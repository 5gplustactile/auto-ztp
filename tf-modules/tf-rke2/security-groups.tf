resource "aws_security_group" "rke2_cluster_sgs" {
  name        = "rke2_cluster_sgs"
  description = "Security group to the first interface"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "9345 TCP RKE2 supervisor API"
    from_port        = 9345
    to_port          = 9345
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr, var.vpc_cidr_wvl]
  }
  ingress {
    description      = "6443 TCP Kubernetes API"
    from_port        = 6443
    to_port          = 6443
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr, var.vpc_cidr_wvl]
  }
  ingress {
    description      = "8472 UDP Required only for Flannel VXLAN, Canal CNI with VXLAN, Cilium CNI VXLAN, Canal CNI with VXLAN"
    from_port        = 8472
    to_port          = 8472
    protocol         = "udp"
    cidr_blocks      = [var.vpc_cidr, var.vpc_cidr_wvl]
  }
  ingress {
    description      = "10250 TCP kubelet metrics"
    from_port        = 10250
    to_port          = 10250
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr, var.vpc_cidr_wvl]
  }
  ingress {
    description      = "2379 TCP etcd client port"
    from_port        = 2379
    to_port          = 2379
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr, var.vpc_cidr_wvl]
  }
  ingress {
    description      = "2380 TCP etcd peer port"
    from_port        = 2380
    to_port          = 2380
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr, var.vpc_cidr_wvl]
  }
  ingress {
    description      = "2381 TCP etcd metrics port"
    from_port        = 2381
    to_port          = 2381
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr, var.vpc_cidr_wvl]
  }
  ingress {
    description      = "30000-32767 TCP NodePort port range"
    from_port        = 30000
    to_port          = 32767
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr, var.vpc_cidr_wvl]
  }
  ingress {
    description      = "4240 TCP Cilium CNI health checks"
    from_port        = 4240
    to_port          = 4240
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr, var.vpc_cidr_wvl]
  }
  ingress {
    description      = "ICMP Cilium CNI health checks"
    from_port        = -1
    to_port          = -1
    protocol         = "icmp"
    cidr_blocks      = [var.vpc_cidr, var.vpc_cidr_wvl]
  }
  ingress {
    description      = "179 TCP Calico CNI with BGP"
    from_port        = 179
    to_port          = 179
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr, var.vpc_cidr_wvl]
  }
  ingress {
    description      = "4789 UDP Calico CNI with VXLAN"
    from_port        = 4789
    to_port          = 4789
    protocol         = "udp"
    cidr_blocks      = [var.vpc_cidr, var.vpc_cidr_wvl]
  }
  ingress {
    description      = "5473 TCP Calico CNI with Typha"
    from_port        = 5473
    to_port          = 5473
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr, var.vpc_cidr_wvl]
  }
  ingress {
    description      = "9098 TCP Calico Typha health checks"
    from_port        = 9098
    to_port          = 9098
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr, var.vpc_cidr_wvl]
  }
  ingress {
    description      = "9099 TCP Calico health checks, Canal CNI health checks"
    from_port        = 9099
    to_port          = 9099
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr, var.vpc_cidr_wvl]
  }
  ingress {
    description      = "51820 UDP Canal CNI with WireGuard IPv4"
    from_port        = 51820
    to_port          = 51820
    protocol         = "udp"
    cidr_blocks      = [var.vpc_cidr, var.vpc_cidr_wvl]
  }
  ingress {
    description      = "51821 UDP Canal CNI with WireGuard IPv6/dual-stack"
    from_port        = 51821
    to_port          = 51821
    protocol         = "udp"
    cidr_blocks      = [var.vpc_cidr, var.vpc_cidr_wvl]
  }
  ingress {
    description      = "443 TLS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr, var.vpc_cidr_wvl]
  }
  ingress {
    description      = "22 SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr, var.vpc_cidr_wvl]
  }
  ingress {
    description      = "UMA Internal Network"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["10.11.29.0/24"]
  }
  ingress {
    description      = "Edge UMA network"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["172.3.0.0/16"]
  }
  ingress {
    description = "Accept all traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description      = "Allow all traffic wvl worker"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["192.168.0.0/16"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = var.tags
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = var.vpc_name
  description = "Security group to the lni interface"
  vpc_id      = aws_vpc.vpc.id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["all-all"]
  egress_rules        = ["all-all"]

  tags = var.tags
}
resource "aws_security_group" "sgs_vpc_peering" {
  count       = var.cidr_block_vpc_digital_twins != null && var.cidr_block_vpc_digital_twins != "" ? 1 : 0
  name        = "vpc_peering_cluster_mgmt_to_cluster_api"
  description = "Allow traffic from cluster api"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Allow traffic from cluster api"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_block_vpc_digital_twins]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    subject = "vpc peering to connect digital twins vpc with the cluster mgmt vpc"
  }
}


resource "aws_security_group" "sgs_wvl" {
  count = local.worker_in_wvl ? 1 : 0
  
  name        = "sgs_az_wavelength"
  description = "sgs to accept traffic from vpc edge or region"
  vpc_id      = aws_vpc.vpc_wvl[0].id

  ingress {
    description = "Allow traffic from vpc-edge-region"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }
  ingress {
    description      = "Edge UMA network"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["172.3.0.0/16"]
  }
  ingress {
    description      = "Allow traffic to test the region, outpost and wvl latency"
    from_port        = 31900
    to_port          = 31900
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "Allow all traffic wvl worker"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = var.tags
}
