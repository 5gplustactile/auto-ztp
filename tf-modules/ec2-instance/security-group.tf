resource "aws_security_group" "sgs_instance" {
  name        = "allow_all_inbound_ec2_instance"
  description = "Allow all inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "Allow all inbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [data.aws_vpc.vpc_dc.cidr_block]
  }
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = var.tags
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = "sgs-instance-lni"
  description = "Security group to the lni interface"
  vpc_id      = var.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["all-all"]
  egress_rules        = ["all-all"]

  tags = var.tags
}